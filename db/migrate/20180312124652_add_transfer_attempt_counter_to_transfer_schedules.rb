class AddTransferAttemptCounterToTransferSchedules < ActiveRecord::Migration[5.0]
  def change
    add_column :transfer_schedules, :transfer_attempt_counter, :integer
  end
end
