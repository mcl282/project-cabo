module DwollaAppToken

  def DwollaAppToken.get_token
    #Application tokens do not include a refresh_token. When an application token expires, generate a new one using $dwolla.auths.client
    $dwolla.auths.client
    
  end

end