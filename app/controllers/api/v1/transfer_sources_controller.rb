module Api::V1
  class TransferSourcesController < ApiController
    before_action :authenticate_user

    def index
      
      customer = TransferCustomer.customer(current_user.id)
      
      funding_source = customer.fetch_funding_source

      render json: {funding_source_data: funding_source, user: current_user.id}, status: :ok 
      
    end
    
    def create
      
      customer = TransferCustomer.customer(current_user.id)
      
      #before creating, check to see if a valid funding source already exists
      raise "Over funding source limit!" unless customer.within_funding_source_limit?
      
      
      #pull the public token and account id off of the incoming request
      account_info = {
        :public_token => params[:values][:public_token],
        :account_id => params[:values][:account_id],
        :account_name =>  params[:values][:accounts][0]['name'], 
        :account_type => params[:values][:accounts][0]['type'],
        :institution => params[:values][:institution]['name']
      }
      
      customer.create_transfer_source(account_info, current_user.id)

      render status: :created        
      
      rescue Exception => e
      
      render json: e.message.to_json, status: :bad_request
    end
    
    def update_transfer_source
      
      #pull values off the update request
      request_body = request[:values]
      
      #update method
      update_funding_source_response = TransferCustomer.update_funding_source(current_user.id, request_body)

      render json: update_funding_source_response, status: :created        
      
    end

  end
end

