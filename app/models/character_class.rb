class CharacterClass < ActiveRecord::Base
  has_many :levels
  has_many :bp_cost_by_race_classes
  has_many :class_spells
  has_and_belongs_to_many :proficiencies
  has_and_belongs_to_many :talents

  has_many :character_classes_skills
  has_and_belongs_to_many :skills, through: :character_classes_skills
end
