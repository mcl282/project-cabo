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
      
      render json: e['_embedded'][:errors][0].message.to_json, status: :bad_request

      
    end
    
    def update_transfer_customer
      #puts params[:values][:data].to_json
      update_dwolla_customer(current_user.id, params[:values][:data])
      
    end
  private
  
    def update_dwolla_customer(user_id, data)
      customer_url = TransferCustomer.dwolla_customer_url(user_id)
      place_data = data[:placeArray]

      address1 = place_data[0][:long_name] + ' ' + place_data[1][:long_name] + ' '

      city = place_data[4][:long_name]
      state = place_data[5][:short_name] 
      postalCode = place_data[7][:long_name]

#Pasing in typetells Dwolla that you want to create a “Verified Customer” and expects additional fieldsRemove type: 'personal' from your request body and you should be good!    

      request_body = {
            "firstName" => 'John',
            "lastName" => 'Doe',
             "address1" => address1,
             "address2" => data[:address2],
                 "city" => city,
                "state" => state,
           "postalCode" => postalCode,
          "dateOfBirth" => "1984-07-11",
                  "ssn" => "123-45-6711",
                 "type" => "personal",
                "email" => User.find(user_id).email 
      }
      
      resp = TransferCustomer.update_customer(customer_url, request_body)
      puts resp
    end
  end
end

