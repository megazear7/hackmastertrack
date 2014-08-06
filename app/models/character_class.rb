class CharacterClass < ActiveRecord::Base
  has_many :levels
  has_many :bp_cost_by_race_classes
  has_one :class_spellbook
end
