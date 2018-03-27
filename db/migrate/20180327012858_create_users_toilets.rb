class CreateUsersToilets < ActiveRecord::Migration[5.1]
  def change
    create_table :users_toilets do |t|
      t.integer :user_id, null: false
      t.integer :toilet_id, null: false

      t.timestamps
    end
  end
end
