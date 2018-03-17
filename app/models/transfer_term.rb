class TransferTerm < ApplicationRecord
  has_many :transfers
  has_many :transfer_schedules
  monetize :monthly_amount_cents
  

  # Determing number of payments for transfer term
  def self.number_of_payments(transfer_term)
    second_payment_date = transfer_term.start_date.next_month.beginning_of_month
    end_date = transfer_term.end_date
    
    #finds the number of months between 2 dates, then adds 1 to make it inclusive of the first month
    number_of_months = ((end_date.year * 12) + end_date.month) - ((second_payment_date.year * 12) + second_payment_date.month) + 1
    #add 1 for the first month of payment
    number_of_months + 1
    
  end
  
  #returns an array with the payment dates, assuming rent typically gets paid on the first of the month (aside from first payment)
  def self.payment_dates(transfer_term)
    
    start_date = transfer_term.start_date 
    
    number_of_payments = TransferTerm.number_of_payments(transfer_term)
    
    #create an array where each integer represents an individual payment (excluding the first payment which gets inserted later)
    payment_array_ex_first_payment_date = (1..number_of_payments-1).to_a
    
    #create an array of dates for the first of every month (excluding the first payment which gets inserted later)
    dates_ex_first_payment = payment_array_ex_first_payment_date.collect{|payment_number| start_date.next_month.beginning_of_month + (payment_number-1).months }

    #insert first date of payment term into array 
    full_term_payment_dates=dates_ex_first_payment.insert(0, start_date)
    
    #return array of payment dates including the first payment date
    full_term_payment_dates
    
  end

  #determine of value of start month payment  
  def self.beginning_stub_value(transfer_term)
    
    term_start_day = transfer_term.start_date.day.to_f
    
    last_day_of_month = transfer_term.start_date.end_of_month.day.to_f
    
    pct_of_first_month = ((last_day_of_month-term_start_day+1)/last_day_of_month).to_f
    
    pct_of_first_month*transfer_term.monthly_amount
  end

#determine of value of last month payment  
  def self.ending_stub_value(transfer_term)
    term_end_day = transfer_term.end_date.day.to_f
    
    last_day_of_month = transfer_term.end_date.end_of_month.day.to_f
      
    pct_of_last_month = (term_end_day/last_day_of_month).to_f
    
    pct_of_last_month*transfer_term.monthly_amount
  end
  
  #determing which payment value to use (stub, full month, etc)
  def self.payment_value(payment_number, transfer_term)
    
    number_of_payments = TransferTerm.number_of_payments(transfer_term)
    
    monthly_amount = transfer_term.monthly_amount
    
    beginning_stub_value = TransferTerm.beginning_stub_value(transfer_term)

    ending_stub_value = TransferTerm.ending_stub_value(transfer_term)   
    
    #assumes first payment will always be a full month's rent
    if payment_number == 0
      monthly_amount
      
    #apply beginning stub to the second payment, if term starts on the first day this will just be a full month of rent
    elsif payment_number== 1
      beginning_stub_value

    #for the last payment, apply the ending stub value, if term starts on first day of month this iwll just be a full month of rent 
    elsif payment_number == number_of_payments-1
      ending_stub_value

    #all other payments should be the full month amount
    else
      monthly_amount
    end
    
  end
  
  #return an array with payment details for each payment
  def self.transfer_schedule_details(transfer_term)
    
    transfer_term_id = transfer_term.id
    
    payment_dates = TransferTerm.payment_dates(transfer_term)

    payment_dates.each_with_index.collect{|date, index|
      {
        :payment_number =>index, 
        :payment_date =>date, 
        :payment_value =>TransferTerm.payment_value(index, transfer_term), 
        :transfer_term_id =>transfer_term_id
      }
    }
  end
  
  #returns a single schedule transfer
  def self.create_scheduled_transfer(transfer_schedule_details)
    
    single_scheduled_transfer = 
      TransferSchedule.new(
      transfer_term_id: transfer_schedule_details[:transfer_term_id],
      value: transfer_schedule_details[:payment_value],
      initialize_transfer_date: transfer_schedule_details[:payment_date],
      status: 'scheduled'
      )
    
    single_scheduled_transfer.save

  end
  
  #create a group of scheduled transfers from a single transfer term
  def self.create_scheduled_transfer_group(transfer_term)
    
    details = TransferTerm.transfer_schedule_details(transfer_term)
    
    group = details.each{|transfer|
      TransferTerm.create_scheduled_transfer(transfer)
    }
    
    group
    
  end

end