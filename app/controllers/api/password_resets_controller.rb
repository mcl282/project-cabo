class Api::PasswordResetsController < ApplicationController  
  before_action :get_user,   only: [:update]
  before_action :valid_user, only: [:update]
  before_action :check_expiration, only: [:update]


  def create
    @user = User.find_by(email: params[:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      render json: {info: "Email sent with password reset instructions" }, status: :created
    else
      render json: {info: "Email address not found" }, status: :unprocessable_entity
    end
  end
  
  def update
    if params[:newPassword].empty? # Case (3)
      render json: {info: "Password can't be empty" }, status: :unprocessable_entity
    else @user.update_attributes(user_params) # Case (4)
      @user.update_attribute(:reset_digest, nil)
      jwt = Knock::AuthToken.new(payload: {auth: token_params}).token
      render json: {info: "Password has been reset.", jwt: jwt }, status: :created # Case (2)
    end
  end

  private
    def user_params
      params.require(:newPassword).permit(:password)
    end
    
    def get_user
      email = CGI::unescape("#{params[:email]}")
      @user = User.find_by(email: email)
    end

    # Confirms a valid user.
    #:id is just the first parameter in the url (because you've got restful urls)
    def valid_user
      unless (@user && @user.authenticated?(:reset, params[:id]))
      end
    end  
    
    
    # Checks expiration of reset token.
    def check_expiration
      if @user.password_reset_expired?
        render json: {info: "Password reset link has has expired"}, status: :bad_request 
      end
    end

    def token_params
      {email: @user.email, password: params[:newPassword]}
    end    

end
