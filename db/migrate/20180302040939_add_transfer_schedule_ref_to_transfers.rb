class AddTransferScheduleRefToTransfers < ActiveRecord::Migration[5.0]
  def change
    add_reference :transfers, :transfer_schedule_id, foreign_key: true
  end
end
