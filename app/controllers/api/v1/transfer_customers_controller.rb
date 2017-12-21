module Api::V1
  class TransferCustomersController < ApiController
    before_action :authenticate_user    
    
    def create
      app_token = $dwolla.auths.client
      
      #create a new customer

      first_name_value = current_user.first_name ? current_user.first_name : params[:values][:firstName]
      last_name_value = current_user.last_name ? current_user.last_name : params[:values][:lastName]

      request_body = {
        :firstName => first_name_value,
        :lastName => last_name_value,
        :email => current_user.email,
        :ipAddress => request.remote_ip
      }

      
      customer = app_token.post "customers", request_body

      location = customer.response_headers[:location] 

      transfer_customer = TransferCustomer.create(
       user_id: current_user.id,
        location: location)
      
      render json: location.to_json, status: :created        
      
      rescue Exception => e
      
      render json: e._embedded[:errors][0].message.to_json, status: :bad_request

      
    end
    
    def update
      
    end 
  end
end

