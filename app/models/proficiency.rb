class Proficiency < ActiveRecord::Base
  has_and_belongs_to_many :races
  has_and_belongs_to_many :character_classes
  has_and_belongs_to_many :characters
  has_many :items
end
