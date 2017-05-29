module Api::V1
  class ApiController < ActionController::API
    include Knock::Authenticable
  end
end