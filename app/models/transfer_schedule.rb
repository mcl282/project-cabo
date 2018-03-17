class TransferSchedule < ApplicationRecord
  belongs_to :transfer_term
  belongs_to :transfer
  
  monetize :value_cents
  
  def self.scheduled_transfers_to_process(processing_date)
    TransferSchedule.where("transfer_attempt_counter <= 3")
      .or(TransferSchedule.where(transfer_attempt_counter: nil))
      .where(initialize_transfer_date: processing_date)
      .where.not(status: "processed")
  end
  
  def self.number_of_transfer_requests(transfer_schedule_id)
    Transfer.where(transfer_schedule_id: transfer_schedule_id).length
  end
  
  
  def self.create_transfer_from_transfer_schedule(transfer_schedule_id)
    
    transfer_schedule = TransferSchedule.find(transfer_schedule_id)
    
    transfer_term_id = transfer_schedule.transfer_term_id
    value = transfer_schedule.value 

    transfer_term = TransferTerm.find(transfer_term_id)
    unit_id = transfer_term.unit_id
    
    unit = Unit.find(unit_id)
    
    source_url = TransferCustomer.funding_source_url(unit.tenant_id)
    destination_url = TransferCustomer.funding_source_url(unit.manager_id)
    
    metadata = {
        :transfer_term_id => transfer_term_id,
        :transfer_schedule_id => transfer_schedule_id,
        :unit_id => unit_id
    }
    
    transfer_response = Transfer.create_transfer(
      source_url, 
      destination_url, 
      value.format(:symbol => false), 
      metadata)
    
    status = transfer_response[:request_response].response_status
    transfer_id = transfer_response[:transfer_id]
    
    TransferSchedule.increment_counter(:transfer_attempt_counter, transfer_schedule_id)
    
    transfer_schedule.update(status: "processed", transfer_id: transfer_id) if status == 201 
    
    
  end
  
end
