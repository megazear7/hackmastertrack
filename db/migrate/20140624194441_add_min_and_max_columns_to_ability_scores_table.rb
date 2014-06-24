class AddMinAndMaxColumnsToAbilityScoresTable < ActiveRecord::Migration
  def change
    add_column :ability_scores, :min, :float
    add_column :ability_scores, :max, :float
  end
end
