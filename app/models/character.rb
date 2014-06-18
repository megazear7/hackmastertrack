class Character < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :items
  has_and_belongs_to_many :talents
  has_and_belongs_to_many :proficiencies
  has_and_belongs_to_many :skills
  has_and_belongs_to_many :spells
  has_and_belongs_to_many :campaigns

  belongs_to :mentor, :class_name => "Character"
  has_many :prodigees, :foreign_key => "mentor_id"

  def level
    case self.exp
    when 0..399
      1
    when 400..1199
      2
    when 1200..2199
      3
    when 2200..3399
      4
    when 3400..4849
      5
    when 4850..6599
      6
    when 6600..8699
      7
    when 8700..11199
      8
    when 11200..14149
      9
    when 14150..99999 # I dont know about levels 11+
      10
    end
  end

end
