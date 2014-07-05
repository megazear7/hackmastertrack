class CreateBpCostByRaceClasses < ActiveRecord::Migration
  def change
    create_table :bp_cost_by_race_classes do |t|
      t.integer :character_class_id
      t.integer :race_id
      t.integer :bp_cost
      t.timestamps
    end
  end
end
