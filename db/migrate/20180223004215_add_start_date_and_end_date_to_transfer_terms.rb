class AddStartDateAndEndDateToTransferTerms < ActiveRecord::Migration[5.0]
  def change
    add_column :transfer_terms, :start_date, :date
    add_column :transfer_terms, :end_date, :date
  end
end
