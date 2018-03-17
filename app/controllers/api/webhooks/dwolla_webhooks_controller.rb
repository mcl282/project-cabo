module Api::Webhooks
  class DwollaWebhooksController < WebhooksController
  before_action :verify_signature
  require 'pp'

    
    
      
    def create
      pp params
      
      case params[:topic]
        when 'customer_funding_source_verified'
          puts '----------customer_funding_source_verified-----------------'
        when 'customer_funding_source_added'
          puts '--------------------customer_funding_source_added-------------'
        when 'customer_funding_source_removed'
          puts '----------remove funding souces-----------------'
        when 'customer_bank_transfer_completed'
          puts '----------customer_bank_transfer_completed-----------------'
          update_transfer_completed
        when 'customer_bank_transfer_failed'
          puts '----------bank_transfer_failed-----------------'
          update_transfer_failed
      end

      
    end
    
    private
    
      def verify_signature
        
        payload_body = request.body.read
        request_signature = request.headers['X-Request-Signature-Sha-256']
        
        signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new("sha256"),
          ENV["DWOLLA_WEBHOOK_SECRET"], payload_body)
      
        unless Rack::Utils.secure_compare(signature, request_signature)
          halt 500, "Signatures didn't match!"
        end
        
      end  
      
      def resource_link
        params[:_links][:resource][:href]
      end
      
      def resource
        Transfer.fetch_transfer_by_link(resource_link)
      end
      

      
      def update_transfer_completed
          #step 1:  pull off the resource link for the completed bank tansfer as resource_link
          resource_link

          #step 2:  look up the resource using Transfer.fetch_transfer_by_link(resource_link), call it resource
          resource

          #step 3:  response will have an attribute of funded-transfer; pull it off as funded_transfer_link
          funded_transfer_link = resource['_links']['funded-transfer']['href']

          #step 4:  look up the funded_transfer_link in the transfer_model to find the original transfer; call it transfer_origin
          transfer_origin = Transfer.find_by(link: funded_transfer_link )

          #step 5:  update the resource_status_link column with resource_link and update the transfer_status column with resource[:status]
          transfer_origin.update_attributes(
            resource_status_link: resource_link, 
            transfer_status: resource['status'])      

      end
      
      def update_transfer_failed
        #step 1:  pull off the resource link
        resource_link
        resource
        #step 2: append '/failure' to resource link
        failure_link = resource_link + '/failure'
        #step 3: call the failure link
        failed_transfer = Transfer.fetch_transfer_by_link(failure_link)
        
        #failed_transfer_description = failed_transfer['description']
        #failed_transfer_explanation = failed_transfer['explanation']
        #failed_transfer_code = failed_transfer['code']
        
        #step 4:  look up the funded_transfer_link in the transfer_model to find the original transfer; call it transfer_origin
        transfer_origin = Transfer.find_by(link: resource['_links']['funded-transfer']['href'] )
        
        #step 5:  update the origin transaction
        transfer_origin.update_attributes(
          resource_status_link: resource_link, 
          transfer_status: resource['status'])      
      end
          
  
  end
end




