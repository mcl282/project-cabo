$dwolla = DwollaV2::Client.new(key: ENV["DWOLLA_APP_KEY"], secret: ENV["DWOLLA_APP_SECRET"]) do |config|
  config.environment = :sandbox
  
  #config.on_grant do |token|
  #  TokenData.create! token
  #end
end