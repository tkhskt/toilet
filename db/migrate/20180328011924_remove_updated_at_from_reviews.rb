class RemoveUpdatedAtFromReviews < ActiveRecord::Migration[5.1]
  def change
    remove_column :reviews, :updated_at, :datetime
  end
end
