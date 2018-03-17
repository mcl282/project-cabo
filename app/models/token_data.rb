class TokenData < ApplicationRecord
  attr_encrypted :access_token, key: ENV['SECRET_KEY_ENCRYPTION'] 
end
