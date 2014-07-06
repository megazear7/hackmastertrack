class Character < ActiveRecord::Base
  belongs_to :user
  belongs_to :character_class
  belongs_to :race
  has_and_belongs_to_many :items
  has_and_belongs_to_many :talents
  has_and_belongs_to_many :proficiencies
  has_and_belongs_to_many :skills
  has_and_belongs_to_many :spells
  has_and_belongs_to_many :campaigns
  belongs_to :left_hand_item, class_name: "Item", foreign_key: "left_hand_item_id"
  belongs_to :right_hand_item, class_name: "Item", foreign_key: "right_hand_item_id"
  belongs_to :body_item, class_name: "Item", foreign_key: "body_item_id"
  validates_presence_of :character_class_id, :race_id, :strength, :intelligence, :wisdom, :dexterity, :constitution, :looks, :charisma, :name

  belongs_to :mentor, :class_name => "Character"
  has_many :prodigees, :foreign_key => "mentor_id"

  def calculate_combat_rose equipment = nil
    # if any equipment was passed in, use that in the calcultion instead of the actual equiped items
    equipment_to_calc = {}
    equipment_to_calc["left_hand"]  = (equipment and equipment["left_hand"])  ? equipment["left_hand"]  : self.left_hand_item
    equipment_to_calc["right_hand"] = (equipment and equipment["right_hand"]) ? equipment["right_hand"] : self.right_hand_item
    equipment_to_calc["body"]       = (equipment and equipment["body"])       ? equipment["body"]       : self.body_item

    # calculate all the needed stats, and then return them
    combat_rose = { }
    combat_rose["speed"]            = self.calculate_speed(equipment_to_calc)
    combat_rose["init"]             = self.calculate_init(equipment_to_calc)
    combat_rose["attack"]           = self.calculate_attack(equipment_to_calc)
    combat_rose["defense"]          = self.calculate_defense(equipment_to_calc)
    combat_rose["shield_reduction"] = self.calculate_shield_reduction(equipment_to_calc)
    combat_rose["damage_reduction"] = self.calculate_damage_reduction(equipment_to_calc)
    combat_rose["damage_mod"]       = self.calculate_damage_mod(equipment_to_calc)
    combat_rose["reach"]            = self.calculate_reach(equipment_to_calc)
    combat_rose["top_save"]         = self.calculate_top_save(equipment_to_calc)
    combat_rose["left_hand"]        = equipment_to_calc["left_hand"]
    combat_rose["right_hand"]       = equipment_to_calc["right_hand"]
    combat_rose["body"]             = equipment_to_calc["body"]
    combat_rose
  end

  def build_equipment equipment
    # this will keep the equipment passed in the same, unless it was nil, in which case it will build
    # a hash with all the equipment that the character has equiped
    if equipment.nil?
      equipment_to_calc = {}
      equipment_to_calc["left_hand"]  = self.left_hand_item
      equipment_to_calc["right_hand"] = self.right_hand_item
      equipment_to_calc["body"]       = self.body_item
      equipment
    else
      equipment
    end
  end

  def calculate_speed equipment
    equipment = build_equipment(equipment)
    mod = 0
    mod += equipment["left_hand"].speed_mod  if equipment["left_hand"]  and equipment["left_hand"].speed_mod
    mod += equipment["right_hand"].speed_mod if equipment["right_hand"] and equipment["right_hand"].speed_mod
    mod += equipment["body"].speed_mod       if equipment["body"]       and equipment["body"].speed_mod
    mod
  end

  def calculate_init equipment
    equipment = build_equipment(equipment)
    mod = 0
    mod += AbilityScore.find_ability_mod("Wisdom", self.wisdom, "init_mod")
    mod += AbilityScore.find_ability_mod("Dexterity", self.dexterity, "init_mod")
    mod += equipment["left_hand"].init_mod  if equipment["left_hand"]  and equipment["left_hand"].init_mod
    mod += equipment["right_hand"].init_mod if equipment["right_hand"] and equipment["right_hand"].init_mod
    mod += equipment["body"].init_mod       if equipment["body"]       and equipment["body"].init_mod
    mod
  end

  def calculate_attack equipment
    equipment = build_equipment(equipment)
    mod = 0
    mod += AbilityScore.find_ability_mod("Intelligence", self.intelligence, "attack_mod")
    mod += AbilityScore.find_ability_mod("Dexterity", self.dexterity, "attack_mod")
    mod += equipment["left_hand"].attack_mod  if equipment["left_hand"]  and equipment["left_hand"].attack_mod
    mod += equipment["right_hand"].attack_mod if equipment["right_hand"] and equipment["right_hand"].attack_mod
    mod += equipment["body"].attack_mod       if equipment["body"]       and equipment["body"].attack_mod
    mod
  end

  def calculate_defense equipment
    equipment = build_equipment(equipment)
    mod = 0
    mod += AbilityScore.find_ability_mod("Wisdom", self.wisdom, "defense_mod")
    mod += AbilityScore.find_ability_mod("Dexterity", self.dexterity, "defense_mod")
    mod += equipment["left_hand"].defense_mod  if equipment["left_hand"]  and equipment["left_hand"].defense_mod
    mod += equipment["right_hand"].defense_mod if equipment["right_hand"] and equipment["right_hand"].defense_mod
    mod += equipment["body"].defense_mod       if equipment["body"]       and equipment["body"].defense_mod
    mod
  end

  def calculate_shield_reduction equipment
    equipment = build_equipment(equipment)
    mod = 0
    # TODO calculate shield reduction based off of shield size, first you need to figure out which item 
    # the sheild is, left or right
    mod
  end

  def calculate_damage_reduction equipment
    equipment = build_equipment(equipment)
    mod = 0
    # mise well add the hand items in this, who knows... maybe they magically give you damage reduction
    mod += equipment["left_hand"].damage_reduction  if equipment["left_hand"]  and equipment["left_hand"].damage_reduction
    mod += equipment["right_hand"].damage_reduction if equipment["right_hand"] and equipment["right_hand"].damage_reduction
    mod += equipment["body"].damage_reduction       if equipment["body"]       and equipment["body"].damage_reduction
    mod
  end

  def calculate_damage_mod equipment
    equipment = build_equipment(equipment)
    mod = 0
    mod += AbilityScore.find_ability_mod("Strength", self.strength, "damage_mod")
    # TODO for now, we are assuming we are attacking with the left hand weapon
    mod += equipment["left_hand"].damage_mod  if equipment["left_hand"]  and equipment["left_hand"].damage_mod
    mod += equipment["right_hand"].damage_mod if equipment["right_hand"] and equipment["right_hand"].damage_mod
    mod += equipment["body"].damage_mod       if equipment["body"]       and equipment["body"].damage_mod
    mod
  end

  def calculate_reach equipment
    equipment = build_equipment(equipment)
    mod = 0
    # TODO for now, we are assuming we are attacking with the left hand weapon
    mod = equipment["left_hand"].reach if equipment["left_hand"] and equipment["left_hand"].reach
    mod
  end

  def calculate_top_save equipment
    equipment = build_equipment(equipment)
    mod = (self.constitution / 2).round(0)
    mod
  end

  def actual_level
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

  def needs_to_level
    if not self.level.nil? and self.level < self.actual_level
      true
    else
      false
    end
  end

end
