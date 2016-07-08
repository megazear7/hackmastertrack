class Skill < ActiveRecord::Base
  has_and_belongs_to_many :characters
  has_and_belongs_to_many :races_skills
  has_many :races, through: :races_skills
end
