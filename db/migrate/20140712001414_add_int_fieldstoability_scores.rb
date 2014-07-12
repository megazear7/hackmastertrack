class AddIntFieldstoabilityScores < ActiveRecord::Migration
  def change
    add_column :ability_scores, :max_spells_per_level, :integer
    add_column :ability_scores, :chance_to_learn_spell, :integer
  end
end
