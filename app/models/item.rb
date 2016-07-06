class Item < ActiveRecord::Base
  has_and_belongs_to_many :characters
  has_many    :talents # these talents require this item to be used
  belongs_to  :proficiency # this is the proficiency needed for this item
  has_one :item_instance
  scope :weapons, -> { where("item_type = 'melee' OR item_type = 'ranged' OR item_type = 'polearm'") }
  scope :magic_items, -> { where("magic_level > 5") }
  scope :non_magic_items, -> { where("magic_level < 5") }
  scope :normal_items, -> { where("magic_level = 0") }

  def self.melee_specializations
    [ "attack", "speed", "defense", "damage" ]
  end

  def self.ranged_specializations
    [ "attack", "speed", "damage" ]
  end

  def specializations
    if self.item_type == "ranged"
      Item.ranged_specializations
    else
      Item.melee_specializations
    end
  end

  def is_weapon
    Item.weapons.pluck(:id).include? self.id
  end

  def is_shield?
    item_type == "shield"
  end

  def prof_adjustment
    adjustment = 0
    if    skill_level == "minimal"
      adjustment = -1
    elsif skill_level == "low"
      adjustment = -2
    elsif skill_level == "medium"
      adjustment = -4
    elsif skill_level == "high"
      adjustment = -6
    end
    adjustment
  end

  def self.shield_penalty
    # The penalty for using a shield but not having the proficiency
    -4
  end
end
