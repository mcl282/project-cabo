module Api::V1
  class ChargesController < ApiController
    before_action :authenticate_user
    
    def create
      # Amount in cents
      @amount = 500
    
      customer = Stripe::Customer.create(
        :email => current_user.email,
        :source  => params[:stripeToken][:id]
      )
    
      charge = Stripe::Charge.create(
        :customer    => customer.id,
        :amount      => @amount,
        :description => 'Rails Stripe customer',
        :currency    => 'usd'
      )
      
      purchase = Purchase.create(
        user_id: current_user.id, 
        stripe_charge_id: charge.id)
        
      render json: Purchase.where(stripe_charge_id: charge.id), status: :created        
    
    rescue Stripe::CardError => e
      render body: e.message, status: :unprocessable_entity
      
    end
  end
end
