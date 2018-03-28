class AddDefaultValueToToilets < ActiveRecord::Migration[5.1]
  def change
    change_column :toilets, :image_path, :string, default: "https://maps.gstatic.com/mapfiles/place_api/icons/generic_business-71.png"
  end
end
