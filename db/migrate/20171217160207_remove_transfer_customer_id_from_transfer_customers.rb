class RemoveTransferCustomerIdFromTransferCustomers < ActiveRecord::Migration[5.0]
  def change
    remove_column :transfer_customers, :transfer_customer_id, :string
  end
end
