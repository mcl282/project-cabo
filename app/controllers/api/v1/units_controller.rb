module Api::V1
  class UnitsController < ApiController
    before_action :authenticate_user
    before_action :set_unit, only: [:show, :update, :destroy]
    before_action :set_property, only: [:show, :index]
    
    # GET /units
    def index
      
      units_managed = @property.units.where(manager_id: current_user.id)
      units_tenant = @property.units.where(tenant_id: current_user.id)
      
      render json: {units_managed: units_managed, units_tenant: units_tenant}

    end
  
    # GET /units/1
    def show
      puts params.to_h
      render json: @unit
    end
  
    # POST /units
    def create
      puts 'this got called in the units controller!'
      pp params
      # unit = current_user.property.unit.build(micropost_params)

  
      # if unit.save
      #   render json: unit, status: :created
      # else
      #   render json: unit.errors, status: :unprocessable_entity
      # end
    end
  
    # PATCH/PUT /units/1
    def update
      if @unit.update(unit_params)
        render json: @unit
      else
        render json: @unit.errors, status: :unprocessable_entity
      end
    end
  
    # DELETE /units/1
    def destroy
      @unit.destroy
    end
  
    private
      # Use callbacks to share common setup or constraints between actions.
      def set_unit
        @unit = Unit.find(params[:id])
        puts @unit
        pp params
      end
      
      def set_property
        @property = Property.find(params[:property_id])
        
      end
      
      # Only allow a trusted parameter "white list" through.
      def unit_params
        params.require(:unit).permit(:street_number, :route, :unit, :locality, :administrative_area_level_1, :country, :postal_code, :google_place_id, :zillow_zpid, :unit_name)
      end
      
  end
end