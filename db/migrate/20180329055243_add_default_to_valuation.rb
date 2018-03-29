class AddDefaultToValuation < ActiveRecord::Migration[5.1]
  def change
    change_column :toilets, :valuation, :float, default: 0.0
  end
end
