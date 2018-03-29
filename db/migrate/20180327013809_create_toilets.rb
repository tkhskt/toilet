class CreateToilets < ActiveRecord::Migration[5.1]
  def change
    create_table :toilets do |t|
      t.string :name
      t.string :google_id
      t.float :lat, null: false
      t.float :lng, null: false
      t.string :geolocation
      t.string :image_path
      t.string :description
      t.float :valuation
      t.datetime :updated_at

      t.timestamps
    end
  end
end
