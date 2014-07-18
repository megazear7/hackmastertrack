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

  has_many :item_instances # these are equiped items

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

  def pdf_url
    "https://www.webmerge.me/merge/14785/ukwgj8?download=1"
  end

  def plusinfront (number)
    return "+" + number.to_s if number > 0
    return number
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
    args["level"] = self.level if self.level
    args["alignment"] = self.alignment.name if self.alignment
    args["sex"] = self.sex.name if self.sex
    args["age"] = self.age if self.age
    args["height"] = self.height if self.height
    args["weight"] = self.weight if self.weight
    args["hair"] = self.hair.name if self.hair
    args["eyes"] = self.eyes.name if self.eyes
    args["handedness"] = self.handedness.name if self.handedness
    #args["patron_gods"] = self.patron_gods.name if self.patron_gods
    #args["anointed_y"] = "X" if self.anointed == "Yes"
    #args["anointed_n"] = "X" if self.anointed == "No"
    args["building_points"] = self.building_points if self.building_points
    args["experience"] = self.exp if self.exp
    args["hit_points"] = self.health if self.health

    # Combat Rose

    #args["shield_defense_bonus"] = self.  if self.
    #args[" shield_damage_reduction "] = self.  if self.
    #args["fatigue_factor"] = self.  if self.
    #args["threshold_of_pain"] = self.  if self.
    #args["previous_hit_point_roll"] = self.  if self.  
    # body_equiped
    # shield_equiped
    # body_equiped_damage_reduction

    # Money

    args["trade_coins"] = self.trade_coins if self.trade_coins
    args["cp"] = self.copper if self.copper
    args["sp"] = self.silver if self.silver
    args["gp"] = self.gold if self.gold

    # Honor

    # hon_window
    # honor
    # fame
    # hon_penalty_window
    # hon_bonus
    # category_of_fame
    # hero_morale
    # fearless_morale
    # brave_morale
    # steady_morale
    # nervous_morale
    # cowardly_morale

    # Strength

    args["str"] = self.strength.to_i
    args["str_percent"] =  fract_extract self.strength if self.strength

    args["feat_of_strength"] = plusinfront AbilityScore.find_ability_mod("Strength", self.strength, "feat_of_strength")
    args["str_damage_mod"] = plusinfront AbilityScore.find_ability_mod("Strength", self.strength, "damage_mod")
    args["profile_1_abilities_damage"] = plusinfront AbilityScore.find_ability_mod("Strength", self.strength, "damage_mod")
    args["str_lift"] =  AbilityScore.find_ability_mod("Strength", self.strength, "lift")
    args["str_carry"] = AbilityScore.find_ability_mod("Strength", self.strength, "carry")
    args["str_drag"] =  AbilityScore.find_ability_mod("Strength", self.strength, "drag")

    # Intelligence

    args["int"] = self.intelligence.to_i
    args["int_percent"] = fract_extract self.intelligence if self.intelligence

    args["int_attack_mod"] = plusinfront AbilityScore.find_ability_mod("Intelligence", self.intelligence, "attack_mod")

    # Wisdom
    args["wis"] = self.wisdom.to_i
    args["wis_percent"] = fract_extract self.wisdom if self.wisdom

    args["wis_init_mod"] = plusinfront AbilityScore.find_ability_mod("Wisdom", self.wisdom, "init_mod")
    args["mental_saving_throw_bonus"] = plusinfront AbilityScore.find_ability_mod("Wisdom", self.wisdom, "mental_saving_throw_bonus")
    args["wis_defense_mod"] = plusinfront AbilityScore.find_ability_mod("Wisdom", self.wisdom, "defense_mod")

    # Dexterity
    args["dex"] = self.dexterity.to_i
    args["dex_percent"] = fract_extract self.dexterity if self.dexterity

    args["des_attack_mod"] = plusinfront AbilityScore.find_ability_mod("Dexterity", self.dexterity, "attack_mod")
    args["profile_1_abilities_attack_bonus"] = plusinfront (AbilityScore.find_ability_mod("Dexterity", self.dexterity, "attack_mod") + AbilityScore.find_ability_mod("Intelligence", self.intelligence, "attack_mod"))

    args["des_init_mod"] = plusinfront AbilityScore.find_ability_mod("Dexterity", self.dexterity, "init_mod")
    args["profile_1_abilities_init"] = plusinfront (AbilityScore.find_ability_mod("Dexterity", self.dexterity, "init_mod") + AbilityScore.find_ability_mod("Wisdom", self.wisdom, "init_mod"))

    args["dex_defense_mod"] = plusinfront AbilityScore.find_ability_mod("Dexterity", self.dexterity, "defense_mod")
    args["profile_1_abilities_defense"] = plusinfront (AbilityScore.find_ability_mod("Wisdom", self.wisdom, "defense_mod") + AbilityScore.find_ability_mod("Dexterity", self.dexterity, "defense_mod"))

    args["dodge_saving_throw_bonus"] = plusinfront AbilityScore.find_ability_mod("Dexterity", self.dexterity, "dodge_saving_throw_bonus")
    args["feat_of_agility"] = plusinfront AbilityScore.find_ability_mod("Strength", self.dexterity, "physical_saving_throw_bonus")
    args["physical_saving_throw_bonus"] = plusinfront AbilityScore.find_ability_mod("Dexterity", self.dexterity, "physical_saving_throw_bonus")

    # Constitituion
    args["con"] = self.constitution.to_i
    args["con_percent"] = fract_extract self.constitution if self.constitution

    # Looks
    args["lks"] = self.looks.to_i
    args["lks_percent"] = fract_extract self.looks if self.looks

    # Charisma
    args["cha"] = self.charisma.to_i
    args["cha_percent"] = fract_extract self.charisma if self.charisma
    args["turning_mod"] = plusinfront AbilityScore.find_ability_mod("Charisma", self.charisma, "turning_mod")
    args["morale_mod"] = plusinfront AbilityScore.find_ability_mod("Charisma", self.charisma, "morale_mod")

    args["profile_1_abilities_speed"] = "--"

    # and so on...

    # these are the rest that I am not sure how to map them
    # item_1
    # item_loc_1
    # magic_item_1
    # magic_item_loc_1
    # magic_item_note_1
    # profile_1_s_m
    # combat_profile_weapon_1
    # profile_1_attack_bonus
    # profile_1_level_attack_bonus
    # profile_1_level_speed
    # profile_1_level_init
    # profile_1_level_defense
    # profile_1_level_damage

    # profile_1_speed
    # profile_1_init
    # profile_1_defense
    # profile_1_damage
    # profile_1_reach
    # profile_1_base_weapon_speed
    # profile_1_base_weapon_damage

    # profile_1_spec_attack_1
    # profile_1_spec_speed_1
    # profile_1_spec_defense_1
    # profile_1_spec_damage_1

    # profile_1_spec_attack_2
    # profile_1_spec_speed_2
    # profile_1_spec_m_2
    # profile_1_spec_damage_2

    # profile_1_spec_speed_3
    # profile_1_spec_defense_3
    # profile_1_spec_damage_3
    # profile_1_spec_attack_3

    # profile_1_spec_speed_4
    # profile_1_spec_defense_4
    # profile_1_spec_damage_4
    # profile_1_spec_attack_4

    # profile_1_spec_speed_5
    # profile_1_spec_defense_5
    # profile_1_spec_damage_5
    # profile_1_spec_attack_5

    # location
    # talent_1
    # talent_benefit_1

    # prof_1
    # prof_2
    # prof_3
    # prof_4
    # prof_5
    # prof_6
    # prof_7
    # prof_8
    # prof_9
    # prof_10
    # prof_11
    # prof_12

    # check this url for the pdf field names:
    # https://www.webmerge.me/manage/documents?page=edit&step=test&document_id=14785
    # username: alexlockhart7@gmail.com
    # password: dontopenthecrypt
    args
  end

end
