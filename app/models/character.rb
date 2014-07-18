class Character < ActiveRecord::Base
  attr_accessor :item_to_take
  belongs_to :user
  belongs_to :character_class
  belongs_to :race
  has_and_belongs_to_many :items
  has_and_belongs_to_many :talents
  has_and_belongs_to_many :proficiencies
  has_and_belongs_to_many :skills
  has_and_belongs_to_many :spells
  has_and_belongs_to_many :campaigns
  belongs_to :left_hand_item, class_name: "ItemInstance", foreign_key: "left_hand_item_id"
  belongs_to :right_hand_item, class_name: "ItemInstance", foreign_key: "right_hand_item_id"
  belongs_to :body_item, class_name: "ItemInstance", foreign_key: "body_item_id"
  validates_presence_of :character_class_id, :race_id, :strength, :intelligence, :wisdom, :dexterity, :constitution, :looks, :charisma, :name

  has_many :item_instances # these are equiped items

  def item_instance_names
    # this can be done with a join sql query... but I can't figure it out TODO
    item_instances = []
    self.item_instances.each do |item_instance|
      item_instances << [item_instance.item.name, item_instance.id]
    end
    item_instances
  end

  belongs_to :mentor, :class_name => "Character"
  has_many :prodigees, :foreign_key => "mentor_id"

  def give_race_benefits
    # TODO make sure the names are correct and build associations
    # between skills, talents and proficiencies and 'self' character
    if    self.race.name == "Dwarf"
    elsif self.race.name == "Elf"
    elsif self.race.name == "Gnome"
    elsif self.race.name == "Gnome Titan"
    elsif self.race.name == "Grel"
    elsif self.race.name == "Half-Elf"
    elsif self.race.name == "Half-Hobgoblin"
    elsif self.race.name == "Half-Orc"
    elsif self.race.name == "Halfling"
    elsif self.race.name == "Human"
    end
  end

  def give_class_benefits
    # TODO make sure the names are correct and build associations
    # between skills, talents and proficiencies and 'self' character
    if    self.character_class.name == "Fighter"
    elsif self.character_class.name == "Ranger"
    elsif self.character_class.name == "Barbarian"
    elsif self.character_class.name == "Thief"
    elsif self.character_class.name == "Rogue"
    elsif self.character_class.name == "Assassin"
    elsif self.character_class.name == "Mage"
    elsif self.character_class.name == "Fighter/Theif"
    elsif self.character_class.name == "Fighter/Mage"
    elsif self.character_class.name == "Mage/Thief"
    elsif self.character_class.name == "Cleric"
    end
  end

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
    mod += equipment["left_hand"].item.speed_mod  if equipment["left_hand"]  and equipment["left_hand"].item.speed_mod
    mod += equipment["right_hand"].item.speed_mod if equipment["right_hand"] and equipment["right_hand"].item.speed_mod
    mod += equipment["body"].item.speed_mod       if equipment["body"]       and equipment["body"].item.speed_mod
    mod
  end

  def calculate_init equipment
    equipment = build_equipment(equipment)
    mod = 0
    mod += AbilityScore.find_ability_mod("Wisdom", self.wisdom, "init_mod")
    mod += AbilityScore.find_ability_mod("Dexterity", self.dexterity, "init_mod")
    mod += equipment["left_hand"].item.init_mod  if equipment["left_hand"]  and equipment["left_hand"].item.init_mod
    mod += equipment["right_hand"].item.init_mod if equipment["right_hand"] and equipment["right_hand"].item.init_mod
    mod += equipment["body"].item.init_mod       if equipment["body"]       and equipment["body"].item.init_mod
    mod
  end

  def calculate_attack equipment
    equipment = build_equipment(equipment)
    mod = 0
    mod += AbilityScore.find_ability_mod("Intelligence", self.intelligence, "attack_mod")
    mod += AbilityScore.find_ability_mod("Dexterity", self.dexterity, "attack_mod")
    mod += equipment["left_hand"].item.attack_mod  if equipment["left_hand"]  and equipment["left_hand"].item.attack_mod
    mod += equipment["right_hand"].item.attack_mod if equipment["right_hand"] and equipment["right_hand"].item.attack_mod
    mod += equipment["body"].item.attack_mod       if equipment["body"]       and equipment["body"].item.attack_mod
    mod
  end

  def calculate_defense equipment
    equipment = build_equipment(equipment)
    mod = 0
    mod += AbilityScore.find_ability_mod("Wisdom", self.wisdom, "defense_mod")
    mod += AbilityScore.find_ability_mod("Dexterity", self.dexterity, "defense_mod")
    mod += equipment["left_hand"].item.defense_mod  if equipment["left_hand"]  and equipment["left_hand"].item.defense_mod
    mod += equipment["right_hand"].item.defense_mod if equipment["right_hand"] and equipment["right_hand"].item.defense_mod
    mod += equipment["body"].item.defense_mod       if equipment["body"]       and equipment["body"].item.defense_mod
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
    mod += equipment["left_hand"].item.damage_reduction  if equipment["left_hand"]  and equipment["left_hand"].item.damage_reduction
    mod += equipment["right_hand"].item.damage_reduction if equipment["right_hand"] and equipment["right_hand"].item.damage_reduction
    mod += equipment["body"].item.damage_reduction       if equipment["body"]       and equipment["body"].item.damage_reduction
    mod
  end

  def calculate_damage_mod equipment
    equipment = build_equipment(equipment)
    mod = 0
    mod += AbilityScore.find_ability_mod("Strength", self.strength, "damage_mod")
    # TODO for now, we are assuming we are attacking with the left hand weapon
    mod += equipment["left_hand"].item.damage_mod  if equipment["left_hand"]  and equipment["left_hand"].item.damage_mod
    mod += equipment["right_hand"].item.damage_mod if equipment["right_hand"] and equipment["right_hand"].item.damage_mod
    mod += equipment["body"].item.damage_mod       if equipment["body"]       and equipment["body"].item.damage_mod
    mod
  end

  def calculate_reach equipment
    equipment = build_equipment(equipment)
    mod = 0
    # TODO for now, we are assuming we are attacking with the left hand weapon
    mod = equipment["left_hand"].item.reach if equipment["left_hand"] and equipment["left_hand"].item.reach
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

  def pdf_url
    "https://www.webmerge.me/merge/14785/ukwgj8?download=1"
  end

  def fract_extract (number)
    x = (number - number.to_i) * 100
    x = x.to_i
    return "0" + x.to_s if x < 10 
    return x
  end

  def pdf_fields
    args = {} 
    args["name"] = self.name
    args["class"] = self.character_class.name if self.character_class
    args["race"] = self.race.name if self.race
    args["str"] = self.strength.to_i
    args["int"] = self.intelligence.to_i
    args["wis"] = self.wisdom.to_i
    args["dex"] = self.dexterity.to_i
    args["con"] = self.constitution.to_i
    args["lks"] = self.looks.to_i
    args["cha"] = self.charisma.to_i
    args["str_percent"] =  fract_extract self.strength if self.strength
    args["int_percent"] = fract_extract self.intelligence if self.intelligence
    args["wis_percent"] = fract_extract self.wisdom if self.wisdom
    args["dex_percent"] = fract_extract self.dexterity if self.dexterity
    args["con_percent"] = fract_extract self.constitution if self.constitution
    args["lks_percent"] = fract_extract self.looks if self.looks
    args["cha_percent"] = fract_extract self.charisma if self.charisma
    args["feat_of_strength"] = AbilityScore.find_ability_mod("Strength", self.strength, "feat_of_strength")
    # and so on...
    # check this url for the pdf field names:
    # https://www.webmerge.me/manage/documents?page=edit&step=test&document_id=14785
    # username: alexlockhart7@gmail.com
    # password: dontopenthecrypt
    args
  end

end
