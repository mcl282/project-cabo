module Api::V1
  class TransfersController < ApiController
    def create
      
      transfer = {:source_customer_id => 41,:destination_customer_id => 41, :value => 10.00}
      
      TransferCustomer.create_transfer(transfer)
      
    end
  end
end


