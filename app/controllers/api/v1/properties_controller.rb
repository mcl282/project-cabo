module Api::V1
  class PropertiesController < ApiController
    before_action :authenticate_user
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
      address_components = params[:address_components]
      
      address = {
        :street_number => address_components[0][:short_name],  
        :route => address_components[1][:long_name],
        :locality => address_components[3][:long_name],
        :administrative_area_level_1 => address_components[5][:short_name],
        :country => address_components[6][:long_name],
        :postal_code => address_components[7][:long_name],
        :google_place_id => params[:id]
      }
      
      property = Property.new(address)
  
      if property.save
        render json: property, status: :created
      else
        render json: property.errors, status: :unprocessable_entity
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