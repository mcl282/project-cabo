class AddUnitRefToTransferTerms < ActiveRecord::Migration[5.0]
  def change
    add_reference :transfer_terms, :unit, foreign_key: true
  end
end
