class AddPreferentialTalents < ActiveRecord::Migration
  def change
    create_table :preferential_races_talents do |t|
      t.integer :race_id
      t.integer :talent_id
      t.integer :percent_cost
    end
  end
end
