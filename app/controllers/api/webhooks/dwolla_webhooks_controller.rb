module Api::Webhooks
  class DwollaWebhooksController < WebhooksController
  before_action :verify_signature
  
    def create
      
      case params[:topic]
      when 'customer_funding_source_verified'
        puts '----------customer_funding_source_verified-----------------'
      when 'customer_funding_source_added'
        puts '--------------------customer_funding_source_added-------------'
      when 'customer_funding_source_removed'
        puts '----------remove funding souces-----------------'
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
          
  
  end
end