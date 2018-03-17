module PlaidToken

  def self.get_token
    Plaid::Client.new(
          env: :sandbox,
          client_id: ENV["PLAID_CLIENT_ID"],
          secret: ENV["PLAID_SECRET"],
          public_key: ENV["PLAID_PUBLIC_KEY"]) 
  end

end