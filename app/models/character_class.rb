class CharacterClass < ActiveRecord::Base
  has_many :levels
  has_many :bp_cost_by_race_classes
end
