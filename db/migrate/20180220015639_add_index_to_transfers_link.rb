class AddIndexToTransfersLink < ActiveRecord::Migration[5.0]
  def change
    add_index :transfers, :link
  end
end


