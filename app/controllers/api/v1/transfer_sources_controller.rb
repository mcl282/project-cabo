module Api::V1
  class TransferSourcesController < ApiController
    before_action :authenticate_user, :initiateDwolla
    before_action :initiatePlaid, only: [:create]
    
    def index
      transfer_sources = TransferSource.where(user_id: current_user.id).where.not(removed: true)
      
      source_url = transfer_sources[0][:funding_source_location]
      
      source = @app_token.get source_url
      
      render json: {source: source, transferSourceId: transfer_sources[0].id}, status: :ok 
      
    end
    
    def create
      
      #before creating, check to see if a valid funding source already exists
      puts TransferSource.funding_source_exists?(current_user.id)
      if TransferSource.funding_source_exists?(current_user.id) then raise end;

      #pull the public token and account id off of the incoming request
      public_token = params[:values][:public_token]
      account_id = params[:values][:account_id]
      
      account_name = params[:values][:accounts][0]['name']
      account_type = params[:values][:accounts][0]['type']
      institution = params[:values][:institution]['name']
        
        
      # exchange public token for an access token
      exchange_response = @plaid.item.public_token.exchange(public_token)
      access_token = exchange_response['access_token']
      item_id = exchange_response['item_id']
      

      #Per Plaid:  access_tokens and item_ids are the core identifiers that map your end-users to their financial institutions. You should persist these securely and associate them with users of your application. 
      PlaidCredential.create(
        user_id:  current_user.id,
        access_token: access_token,
        item_id:  item_id
        )

      #exchange a plaid access token for a plaid processor token
      #incorrectly documneted by Plaid / Dwolla; see here:  https://github.com/plaid/plaid-ruby/issues/174
      plaid_dwolla_response = @plaid.post_with_auth(
        'processor/dwolla/processor_token/create',
        access_token: access_token,
        account_id: account_id)
          
      processor_token = plaid_dwolla_response['processor_token']      

      #Create a funding source for a Customer using a plaidToken, at Dwolla
      customer_url = TransferCustomer.find_by(user_id: current_user.id).location
        
      request_body = {
        plaidToken: processor_token,
        name: account_name + " @" + institution + " (type: " + account_type + ")"
      }

      funding_source = @app_token.post "#{customer_url}/funding-sources", request_body
      
      #store funding source location to the database  
      location = funding_source.response_headers[:location]         
        
      TransferSource.create(
        user_id: current_user.id,
        funding_source_location:  location,
        removed: false
        )

      render status: :created        
      
      rescue Exception => e
      
      render json: e[:message].to_json, status: :bad_request
    end
    
    def update
      
      funding_source_record = TransferSource.find(params[:id]) 
      funding_source_url = funding_source_record.funding_source_location
      
      
      request_body = request[:values]
      
      
      puts request_body
      
      funding_source = @app_token.post "#{funding_source_url}", request_body
      
      #change funding source status to removed in model
      if request_body[:removed] == true
        puts request_body[:removed] == true
        funding_source_record.update_attributes(request_body.to_hash) 
      end
      
      puts funding_source
      
    end

  private
    def initiateDwolla
      @app_token = $dwolla.auths.client
    end
    
    def initiatePlaid
      #create instance of plaid
      @plaid = Plaid::Client.new(
        env: :sandbox,
        client_id: ENV["PLAID_CLIENT_ID"],
        secret: ENV["PLAID_SECRET"],
        public_key: ENV["PLAID_PUBLIC_KEY"]) 
    end
  end
end


