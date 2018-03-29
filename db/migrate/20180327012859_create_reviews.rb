class CreateReviews < ActiveRecord::Migration[5.1]
  def change
    create_table :reviews do |t|
      t.integer :toilet_id, null: false
      t.integer :user_id, null: false
      t.float :valuation
      t.string :message
      t.datetime :updated_at

      t.timestamps
    end
  end
end
