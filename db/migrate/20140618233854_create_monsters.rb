class CreateMonsters < ActiveRecord::Migration
  def change
    create_table :monsters do |t|
      t.string :name
      t.text :description
      t.text :combat_and_tactics
      t.text :habitat_and_society
      t.text :ecology
      t.text :attack_description
      t.integer :health
      t.boolean :template # i.e. is this entry simply a template to make copies with or is an actual monster to place in an encounter
      t.string :size
      t.string :weight
      t.string :intelligence
      t.integer :fatigue_factor
      t.integer :crawl
      t.integer :walk
      t.integer :jog
      t.integer :run
      t.integer :sprint
      t.integer :physical_save
      t.integer :mental_save
      t.integer :dodge_save
      t.string :activity_cycle
      t.string :no_appearing
      t.integer :chance_in_lair
      t.string :frequency
      t.string :alignment
      t.string :vision_type
      t.string :awareness_and_senses
      t.string :habitat
      t.string :diet
      t.string :organization
      t.string :climate 
      t.string :medicinal_yield
      t.string :spell_component_yield
      t.string :hide_or_trophy
      t.string :treasure
      t.string :edible
      t.string :other_yield
      t.integer :exp_value
      t.integer :will_factor
      t.integer :speed
      t.integer :attack
      t.integer :init
      t.integer :defense
      t.integer :damage_reduction
      t.string :reach
      t.integer :damage
      t.integer :top_save
      t.integer :top_threshold


      t.timestamps
    end
  end
end
