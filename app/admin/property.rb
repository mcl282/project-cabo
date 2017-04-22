ActiveAdmin.register Property do
  permit_params :street_number, :route, :unit, :locality, :administrative_area_level_1, :country, :postal_code, :google_place_id, :zillow_zpid 
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end
  form title: 'Create a New Property' do |f|
    inputs 'Details' do
      input :street_number
      input :route
      input :unit
      input :locality
      input :administrative_area_level_1
      input :country, :as => :string
      input :postal_code
      input :google_place_id
      input :zillow_zpid 
      li "Created at #{f.object.created_at}" unless f.object.new_record?
    end
  end
end

