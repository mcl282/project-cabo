class AddRequestStatusCodeToTransfers < ActiveRecord::Migration[5.0]
  def change
    add_column :transfers, :request_status_code, :integer
  end
end
