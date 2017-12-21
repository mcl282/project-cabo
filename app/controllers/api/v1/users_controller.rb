module Api::V1
  class UsersController < ApiController

  
   # GET /users
  before_action :authenticate_user, only: [:index, :show, :update, :destroy]
  
    def index
      @user = current_user
      render json: @user
  
    end
  
    # GET /users/1
    def show
      @user = User.find(current_user.id)
      render json: @user
    end
  
    # POST /users
    def create
      @user = User.new(user_params)
      
      if @user.save
        jwt = Knock::AuthToken.new(payload: {auth: token_params}).token
  
        render json: {user: @user, jwt: jwt}, status: :created  #, location: @user
      else
        render json: @user.errors.full_messages, status: :unprocessable_entity
      end
    end
  
    # PATCH/PUT /users/1
    def update
      if @user.update(user_params)
        render json: @user
      else
        render json: @user.errors.full_messages, status: :unprocessable_entity
      end
    end
  
    # DELETE /users/1
    def destroy
      @user.destroy
    end
    
    private
      # Use callbacks to share common setup or constraints between actions.
      def set_user
        @user = @User.find(params[:id])
      end
      
      # Only allow a trusted parameter "white list" through.
      def user_params
        params.require(:user).permit(:email, :first_name, :last_name, :password)
      end
      
      def token_params
        params.require(:user).permit(:email, :password)
      end
      
  end

end