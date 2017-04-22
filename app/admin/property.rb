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
  form title: 'A custom title' do |f|
    inputs 'Details' do
      input :street_number
      li "Created at #{f.object.created_at}" unless f.object.new_record?
    end
    panel 'Markup' do
      "The following can be used in the content below..."
    end
    inputs 'Content', :route
    para "Press cancel to return to the list without saving."
    actions
  end
end
