module Api::V1
  class PropertiesController < ApiController
    before_action :set_property, only: [:show, :update, :destroy]
  
    # GET /properties
    def index
      @properties = Property.all
  
      render json: @properties
    end
  
    # GET /properties/1
    def show
      render json: @property
    end
  
    # POST /properties
    def create
      @property = Property.new(property_params)
  
      if @property.save
        render json: @property, status: :created, location: @property
      else
        render json: @property.errors, status: :unprocessable_entity
      end
    end
  
    # PATCH/PUT /properties/1
    def update
      if @property.update(property_params)
        render json: @property
      else
        render json: @property.errors, status: :unprocessable_entity
      end
    end
  
    # DELETE /properties/1
    def destroy
      @property.destroy
    end
  
    private
      # Use callbacks to share common setup or constraints between actions.
      def set_property
        @property = Property.find(params[:id])
      end
  
      # Only allow a trusted parameter "white list" through.
      def property_params
        params.require(:property).permit(:street_number, :route, :unit, :locality, :administrative_area_level_1, :country, :postal_code, :google_place_id, :zillow_zpid)
      end
  end
end