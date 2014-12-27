class Spell < ActiveRecord::Base
  has_many :class_spells
  has_many :character_spells
end
