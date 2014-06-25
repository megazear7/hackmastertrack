class Character < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :items
  has_and_belongs_to_many :talents
  has_and_belongs_to_many :proficiencies
  has_and_belongs_to_many :skills
  has_and_belongs_to_many :spells
  has_and_belongs_to_many :campaigns
  belongs_to :left_hand, class_name: "Character", foreign_key: "left_hand_item_id"
  belongs_to :right_hand, class_name: "Character", foreign_key: "right_hand_item_id"
  belongs_to :body, class_name: "Character", foreign_key: "body_item_id"

  belongs_to :mentor, :class_name => "Character"
  has_many :prodigees, :foreign_key => "mentor_id"

  def calculate_combat_rose equipment = nil

    # if any equipment was passed in, use that in the calcultion instead of the actual equiped items
    left_hand = equipment and equipment["left_hand"] ? equipment["left_hand"] : self.left_hand
    right_hand = equipment and equipment["right_hand"] ? equipment["right_hand"] : self.right_hand
    body = equipment and equipment["body"] ? equipment["body"] : self.body

    # build the equipment hash that we ae going to use to calculate
    equipment_to_calc = {}
    equipment_to_calc["left_hand"]  = left_hand
    equipment_to_calc["right_hand"] = right_hand
    equipment_to_calc["body"]       = body

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
      equipment_to_calc["left_hand"]  = self.left_hand
      equipment_to_calc["right_hand"] = self.right_hand
      equipment_to_calc["body"]       = self.body
      equipment
    else
      equipment
    end
  end

  def calculate_speed equipment
    equipment = build_equipment(equipment)
    mod = 0
    mod
  end

  def calculate_init equipment
    equipment = build_equipment(equipment)
    mod = 0
    mod += AbilityScore.find_ability_mod("Wisdom", self.intelligence, "init_mod")
    mod += AbilityScore.find_ability_mod("Dexterity", self.intelligence, "init_mod")
    mod
  end

  def calculate_attack equipment
    equipment = build_equipment(equipment)
    mod = 0
    ability = AbilityScore.find_ability("Intelligence", self.intelligence)
    mod += ability.attack_mod if ability
    ability = AbilityScore.find_ability("Dexterity", self.intelligence)
    mod += ability.attack_mod if ability
    mod
  end

  def calculate_defense equipment
    equipment = build_equipment(equipment)
    mod = 0
    ability = AbilityScore.find_ability("Wisdom", self.intelligence)
    mod += ability.attack_mod if ability
    ability = AbilityScore.find_ability("Dexterity", self.intelligence)
    mod += ability.attack_mod if ability
    mod
  end

  def calculate_shield_reduction equipment
    equipment = build_equipment(equipment)
    mod = 0
    mod
  end

  def calculate_damage_reduction equipment
    equipment = build_equipment(equipment)
    mod = 0
    mod
  end

  def calculate_damage_mod equipment
    equipment = build_equipment(equipment)
    mod = 0
    ability = AbilityScore.find_ability("Strength", self.strength)
    mod += ability.damage_mod if ability
    mod
  end

  def calculate_reach equipment
    equipment = build_equipment(equipment)
    mod = 0
    mod
  end

  def calculate_top_save equipment
    equipment = build_equipment(equipment)
    mod = 0
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

end
