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
  has_many :specializations
  # the step by step character creation does not allow for this:
  #validates_presence_of :character_class_id, :race_id, :strength, :intelligence, :wisdom, :dexterity, :constitution, :looks, :charisma, :name, :building_points

  has_many :item_instances # these are equiped items

  def item_instance_location_names location
    # this can be done with a join sql query... but I can't figure it out TODO
    item_instances = []
    self.item_instances.each do |item_instance|
      if item_instance.item.location == location
        if item_instance.name.nil?
          item_instances << [item_instance.item.name, item_instance.id]
        else
          item_instances << [item_instance.name, item_instance.id]
        end
      end
    end
    item_instances
  end

  def item_instance_names
    # this can be done with a join sql query... but I can't figure it out TODO
    item_instances = []
    self.item_instances.each do |item_instance|
      if item_instance.name.nil?
        item_instances << [item_instance.item.name, item_instance.id]
      else
        item_instances << [item_instance.name, item_instance.id]
      end
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

  def main_hand_item
    self.handedness == "R" ? self.right_hand_item : self.left_hand_item
  end

  def off_hand_item
    self.handedness == "R" ? self.left_hand_item : self.right_hand_item
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

  def off_hand
    case self.handedness
    when "R"
      "left"
    when "L"
      "right"
    when "A"
      "left"
    end
  end

  def main_hand
    case self.handedness
    when "R"
      "right"
    when "L"
      "left"
    when "A"
      "right"
    end
  end

  def prof_adjustment item
    adjustment = 0
    if    item.skill_level == "minimal"
      adjustment = -1
    elsif item.skill_level == "low"
      adjustment = -2
    elsif item.skill_level == "medium"
      adjustment = -4
    elsif item.skill_level == "high"
      adjustment = -6
    end
    self.proficiencies.pluck(:id).include?(item.proficiency_id) ? 0 : adjustment
  end

  def calculate_speed equipment
    equipment = build_equipment(equipment)
    ret = {}
    if equipment["#{main_hand}_hand"]
      specialization = self.specializations.find_by(item_id: equipment["#{main_hand}_hand"].item.id, stat_name: "speed")
      ret["specialization"] = specialization.value if specialization
    else
      ret["specialization"] = 0
    end
    ret["#{main_hand}_hand_item"] = equipment["#{main_hand}_hand"].item.speed_mod if equipment["#{main_hand}_hand"] and equipment["#{main_hand}_hand"].item.speed_mod
    ret["body_item"] = equipment["body"].item.speed_mod       if equipment["body"]       and equipment["body"].item.speed_mod
    ret["proficiency"] = prof_adjustment(equipment["#{main_hand}_hand"].item) if equipment["#{main_hand}_hand"] and prof_adjustment(equipment["#{main_hand}_hand"].item) != 0
    mod = 0
    ret.each do |key, val|
      mod += val
    end
    ret["val"] = mod
    ret
  end

  def calculate_init equipment
    equipment = build_equipment(equipment)
    ret = {}
    ret["wisdom"] = AbilityScore.find_ability_mod("Wisdom", self.wisdom, "init_mod")
    ret["dexterity"] = AbilityScore.find_ability_mod("Dexterity", self.dexterity, "init_mod")
    ret["#{main_hand}_hand_item"] = equipment["#{main_hand}_hand"].item.init_mod if equipment["#{main_hand}_hand"] and equipment["#{main_hand}_hand"].item.init_mod
    ret["body_item"] = equipment["body"].item.init_mod       if equipment["body"]       and equipment["body"].item.init_mod
    mod = 0
    ret.each do |key, val|
      mod += val
    end
    ret["val"] = mod
    ret
  end

  def calculate_attack equipment
    equipment = build_equipment(equipment)
    ret = {}
    if equipment["#{main_hand}_hand"]
      specialization = self.specializations.find_by(item_id: equipment["#{main_hand}_hand"].item.id, stat_name: "attack")
      ret["specialization"] = specialization.value if specialization
    end
    ret["intelligence"] = AbilityScore.find_ability_mod("Intelligence", self.intelligence, "attack_mod")
    ret["dexterity"] = AbilityScore.find_ability_mod("Dexterity", self.dexterity, "attack_mod")
    ret["#{main_hand}_hand_item"] = equipment["#{main_hand}_hand"].item.attack_mod if equipment["#{main_hand}_hand"] and equipment["#{main_hand}_hand"].item.attack_mod
    ret["body_item"] = equipment["body"].item.attack_mod       if equipment["body"]       and equipment["body"].item.attack_mod
    ret["proficiency"] = prof_adjustment(equipment["#{main_hand}_hand"].item) if equipment["#{main_hand}_hand"] and prof_adjustment(equipment["#{main_hand}_hand"].item) != 0
    mod = 0
    ret.each do |key, val|
      mod += val
    end
    ret["val"] = mod
    ret
  end

  def calculate_defense equipment
    equipment = build_equipment(equipment)
    ret = {}
    if equipment["#{main_hand}_hand"]
      specialization = self.specializations.find_by(item_id: equipment["#{main_hand}_hand"].item.id, stat_name: "defense")
      ret["specialization"] = specialization.value if specialization
    end
    ret["wisdom"] = AbilityScore.find_ability_mod("Wisdom", self.wisdom, "defense_mod")
    ret["dexterity"] = AbilityScore.find_ability_mod("Dexterity", self.dexterity, "defense_mod")
    ret["#{main_hand}_hand_item"] = equipment["#{main_hand}_hand"].item.defense_mod if equipment["#{main_hand}_hand"] and equipment["#{main_hand}_hand"].item.defense_mod
    ret["#{off_hand}_hand_item"] = equipment["#{off_hand}_hand"].item.defense_mod if equipment["#{off_hand}_hand"] and equipment["#{off_hand}_hand"].item.defense_mod
    ret["body_item"] = equipment["body"].item.defense_mod       if equipment["body"]       and equipment["body"].item.defense_mod
    ret["proficiency"] = prof_adjustment(equipment["#{main_hand}_hand"].item) if equipment["#{main_hand}_hand"] and prof_adjustment(equipment["#{main_hand}_hand"].item) != 0
    mod = 0
    ret.each do |key, val|
      mod += val
    end
    ret["val"] = mod
    ret
  end

  def calculate_shield_reduction equipment
    equipment = build_equipment(equipment)
    ret = {}
    if equipment["#{off_hand}_hand"] and equipment["#{off_hand}_hand"].item.shield_size
      case equipment["#{off_hand}_hand"].item.shield_size
      when "buckler"
        ret["buckler"] = 4
      when "small"
        ret["small_shield"] = 4
      when "medium"
        ret["medium_shield"] = 6
      when "large"
        ret["large_shield"] = 6
      when "body"
        ret["body_size_shield"] = 6
      end
    end
    ret["#{off_hand}_hand_item"] = equipment["#{off_hand}_hand"].item.item_instance.damage_reduction if equipment["#{off_hand}_hand"] and equipment["#{off_hand}_hand"].item.item_instance and equipment["#{off_hand}_hand"].item.item_instance.damage_reduction
    mod = 0
    ret.each do |key, val|
      mod += val
    end
    ret["val"] = mod
    ret
  end

  def calculate_damage_reduction equipment
    equipment = build_equipment(equipment)
    ret = {}
    ret["body_item"] = equipment["body"].item.damage_reduction       if equipment["body"]       and equipment["body"].item.damage_reduction
    mod = 0
    ret.each do |key, val|
      mod += val
    end
    ret["val"] = mod
    ret
  end

  def calculate_damage_mod equipment
    equipment = build_equipment(equipment)
    ret = {}
    if equipment["#{main_hand}_hand"]
      specialization = self.specializations.find_by(item_id: equipment["#{main_hand}_hand"].item.id, stat_name: "damage")
      ret["specialization"] = specialization.value if specialization
    end
    ret["strength"] = AbilityScore.find_ability_mod("Strength", self.strength, "damage_mod")
    ret["#{main_hand}_hand_item"] = equipment["#{main_hand}_hand"].item.damage_mod if equipment["#{main_hand}_hand"] and equipment["#{main_hand}_hand"].item.damage_mod
    ret["body_item"] = equipment["body"].item.damage_mod       if equipment["body"]       and equipment["body"].item.damage_mod
    ret["proficiency"] = prof_adjustment(equipment["#{main_hand}_hand"].item) if equipment["#{main_hand}_hand"] and prof_adjustment(equipment["#{main_hand}_hand"].item) != 0
    mod = 0
    ret.each do |key, val|
      mod += val
    end
    ret["val"] = mod
    ret
  end

  def calculate_reach equipment
    equipment = build_equipment(equipment)
    ret = {}
    ret["#{main_hand}_hand_item_reach"] = equipment["#{main_hand}_hand"].item.reach if equipment["#{main_hand}_hand"] and equipment["#{main_hand}_hand"].item.reach
    mod = 0
    ret.each do |key, val|
      mod += val
    end
    ret["val"] = mod
    ret
  end

  def calculate_top_save equipment
    equipment = build_equipment(equipment)
    ret = {}
    ret["constitution"] = (self.constitution / 2).round(0)
    mod = 0
    ret.each do |key, val|
      mod += val
    end
    ret["val"] = mod
    ret
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
    args["alignment"] = self.alignment if self.alignment
    args["sex"] = self.sex if self.sex
    args["age"] = self.age if self.age
    args["height"] = self.height if self.height
    args["weight"] = self.weight if self.weight
    args["hair"] = self.hair if self.hair
    args["eyes"] = self.eyes if self.eyes
    args["handedness"] = self.handedness if self.handedness
    #args["patron_gods"] = self.patron_gods.name if self.patron_gods
    #args["anointed_y"] = "X" if self.anointed == "Yes"
    #args["anointed_n"] = "X" if self.anointed == "No"
    args["building_points"] = self.building_points if self.building_points
    args["experience"] = self.exp if self.exp
    args["hit_points"] = self.health if self.health

    # Combat Rose Character sheet doesn't have a combat rose yet
    rose = calculate_combat_rose
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
    args["des_init_mod"] = plusinfront AbilityScore.find_ability_mod("Dexterity", self.dexterity, "init_mod")
    args["dex_defense_mod"] = plusinfront AbilityScore.find_ability_mod("Dexterity", self.dexterity, "defense_mod")
    args["dodge_saving_throw_bonus"] = plusinfront AbilityScore.find_ability_mod("Dexterity", self.dexterity, "dodge_saving_throw_bonus")
    args["feat_of_agility"] = AbilityScore.find_ability_mod("Dexterity", self.dexterity, "feat_of_agility")
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

    # Armor worn

    args["body_equiped"] = self.body_item.item.name if self.body_item
    args["shield_equiped"] = ""
    args["body_equiped_damage_reduction"] = self.body_item.item.damage_reduction if self.body_item
    args["shield_defense_bonus"] = ""
    args["shield_damage_reduction"] = ""

    args["profile_1_notes"] = ""
    if self.main_hand_item
      args["combat_profile_weapon"] = self.main_hand_item.name ? self.main_hand_item.name : self.main_hand_item.item.name
    end

    # Profile 1 Level mods.
    args["profile_1_level_attack"]  = plusinfront Level.find_mod(self.character_class.id, self.level, "attack_mod")
    args["profile_1_level_speed"]   = plusinfront Level.find_mod(self.character_class.id, self.level, "speed_mod")
    args["profile_1_level_init"]    = plusinfront Level.find_mod(self.character_class.id, self.level, "init_mod")
    args["profile_1_level_defense"] = "--"
    args["profile_1_level_damage"]  = "--"

    # Profile 1 Abilities mods.
    args["profile_1_abilities_attack"]  = plusinfront (AbilityScore.find_ability_mod("Dexterity", self.dexterity, "attack_mod") + AbilityScore.find_ability_mod("Intelligence", self.intelligence, "attack_mod"))
    args["profile_1_abilities_speed"]   = "--"
    args["profile_1_abilities_init"]    = plusinfront (AbilityScore.find_ability_mod("Dexterity", self.dexterity, "init_mod") + AbilityScore.find_ability_mod("Wisdom", self.wisdom, "init_mod"))
    args["profile_1_abilities_defense"] = plusinfront (AbilityScore.find_ability_mod("Wisdom", self.wisdom, "defense_mod") + AbilityScore.find_ability_mod("Dexterity", self.dexterity, "defense_mod"))
    args["profile_1_abilities_damage"]  = plusinfront AbilityScore.find_ability_mod("Strength", self.strength, "damage_mod")

    # Profile 1 Specialization mods.
    if self.main_hand_item
      args["profile_1_specialization_attack"]  = self.specializations.find_by(item_id: self.main_hand_item.id, stat_name: "attack") ? (plusinfront self.specializations.find_by(item_id: self.main_hand_item.id, stat_name: "attack").value) : "0"
      args["profile_1_specialization_speed"]   = self.specializations.find_by(item_id: self.main_hand_item.id, stat_name: "speed")  ? (plusinfront self.specializations.find_by(item_id: self.main_hand_item.id, stat_name: "speed").value)  : "0"
      args["profile_1_specialization_init"]    = "--"
      args["profile_1_specialization_defense"] = self.specializations.find_by(item_id: self.main_hand_item.id, stat_name: "defense") ? (plusinfront self.specializations.find_by(item_id: self.main_hand_item.id, stat_name: "defense").value) : "0"
      args["profile_1_specialization_damage"]  = self.specializations.find_by(item_id: self.main_hand_item.id, stat_name: "damage")  ? (plusinfront self.specializations.find_by(item_id: self.main_hand_item.id, stat_name: "damage").value)  : "0"
    else
      args["profile_1_specialization_attack"]  = "--"
      args["profile_1_specialization_speed"]   = "--"
      args["profile_1_specialization_init"]    = "--"
      args["profile_1_specialization_defense"] = "--"
      args["profile_1_specialization_damage"]  = "--"
    end

    # Profile 1 Talent mods. TODO
    args["profile_1_talent_attack"]  = "--"
    args["profile_1_talent_speed"]   = "--"
    args["profile_1_talent_init"]    = "--"
    args["profile_1_talent_defense"] = "--"
    args["profile_1_talent_damage"]  = "--"

    # Profile 1 Race mods.
    args["profile_1_race_attack"]  = "--"
    args["profile_1_race_speed"]   = "--"
    args["profile_1_race_init"]    = "--"
    args["profile_1_race_defense"] = plusinfront Race.find_mod(self.race.name, "defadj")
    args["profile_1_race_damage"]  = "--"

    # Profile 1 Armor mods. TODO
    if self.body_item
      args["profile_1_armor_attack"]  = plusinfront self.body_item.item.attack_mod if body_item.item.attack_mod
      args["profile_1_armor_speed"]   = plusinfront self.body_item.item.speed_mod if body_item.item.speed_mod
      args["profile_1_armor_init"]    = plusinfront self.body_item.item.init_mod if body_item.item.init_mod
      args["profile_1_armor_defense"] = plusinfront self.body_item.item.defense_mod if body_item.item.defense_mod
      args["profile_1_armor_damage"]  = plusinfront self.body_item.item.damage_mod  if body_item.item.damage_mod
    else
      args["profile_1_armor_attack"]  = "--"
      args["profile_1_armor_speed"]   = "--"
      args["profile_1_armor_init"]    = "--"
      args["profile_1_armor_defense"] = "--"
      args["profile_1_armor_damage"]  = "--"
    end

    # Profile 1 Shield mods. TODO
    if self.off_hand_item
      args["profile_1_shield_defense"] = plusinfront self.off_hand_item.item.item_type == "shield" ? self.off_hand_item.item.defense_mod : "--"
    else
      args["profile_1_shield_defense"] = "--"
    end
    args["profile_1_shield_attack"]  = "--"
    args["profile_1_shield_speed"]   = "--"
    args["profile_1_shield_init"]    = "--"
    args["profile_1_shield_damage"]  = "--"

    # Profile 1 Magic mods. TODO
    args["profile_1_magic_attack"]  = "--"
    args["profile_1_magic_speed"]   = "--"
    args["profile_1_magic_init"]    = "--"
    args["profile_1_magic_defense"] = "--"
    args["profile_1_magic_damage"]  = "--"

    # combat_profile_weapon_1
    args["profile_1_attack"]  = plusinfront rose["attack"]["val"]
    args["profile_1_speed"]   = plusinfront rose["speed"]["val"]
    args["profile_1_init"]    = plusinfront rose["init"]["val"]
    args["profile_1_defense"] = plusinfront rose["defense"]["val"]
    args["profile_1_damage"]  = plusinfront rose["damage_mod"]["val"]
    args["profile_1_reach"]   = plusinfront rose["reach"]["val"]
    args["profile_1_base_weapon_speed"]  = self.main_hand_item.item.attack_speed if self.main_hand_item
    args["profile_1_base_weapon_damage"] = self.main_hand_item.item.damage if self.main_hand_item

    if self.main_hand_item and self.specializations.find_by(item_id: main_hand_item.id, stat_name: "speed") and self.specializations.find_by(item_id: main_hand_item.id, stat_name: "speed").value >= 1
      args["profile_1_spec_attack_1"] = "X"
      args["profile_1_spec_speed_1"] = "X"
      args["profile_1_spec_defense_1"] = "X"
      args["profile_1_spec_damage_1"] = "X"
    end

    if self.main_hand_item and self.specializations.find_by(item_id: main_hand_item.id, stat_name: "speed") and self.specializations.find_by(item_id: main_hand_item.id, stat_name: "speed").value >= 2
      args["profile_1_spec_attack_2"] = "X"
      args["profile_1_spec_speed_2"] = "X"
      args["profile_1_spec_defense_2"] = "X"
      args["profile_1_spec_damage_2"] = "X"
    end

    if self.main_hand_item and self.specializations.find_by(item_id: main_hand_item.id, stat_name: "speed") and self.specializations.find_by(item_id: main_hand_item.id, stat_name: "speed").value >= 3
      args["profile_1_spec_attack_3"] = "X"
      args["profile_1_spec_speed_3"] = "X"
      args["profile_1_spec_defense_3"] = "X"
      args["profile_1_spec_damage_3"] = "X"
    end

    if self.main_hand_item and self.specializations.find_by(item_id: main_hand_item.id, stat_name: "speed") and self.specializations.find_by(item_id: main_hand_item.id, stat_name: "speed").value >= 4
      args["profile_1_spec_attack_4"] = "X"
      args["profile_1_spec_speed_4"] = "X"
      args["profile_1_spec_defense_4"] = "X"
      args["profile_1_spec_damage_4"] = "X"
    end

    if self.main_hand_item and self.specializations.find_by(item_id: main_hand_item.id, stat_name: "speed") and self.specializations.find_by(item_id: main_hand_item.id, stat_name: "speed").value >= 5
      args["profile_1_spec_attack_5"] = "X"
      args["profile_1_spec_speed_5"] = "X"
      args["profile_1_spec_defense_5"] = "X"
      args["profile_1_spec_damage_5"] = "X"
    end

    die_bonus = Race.find_mod(self.race.name, "initdiebonus") ? 1 : 0
    die_bonus += Level.find_mod(self.class.name, self.level, "initiativediemod") if die_bonus
    args["profile_1_notes"] += "Initiative die bonus: " + die_bonus.to_s if die_bonus

    self.item_instances.each_with_index do |item_instance, i|
      if (item_instance.magic_level and item_instance.magic_level <= 0) or (not item_instance.magic_level)
        args["item_#{i+1}"] = item_instance.item.name
        args["item_loc_#{i+1}"] = item_instance.item.location
      end
    end

    self.item_instances.each_with_index do |item_instance, i|
      if item_instance.magic_level and item_instance.magic_level > 0
        args["magic_item_#{i+1}"] = item_instance.name ? item_instance.name : item_instance.item.name
        args["magic_item_loc_#{i+1}"] = item_instance.item.location
      end
    end

    self.talents.each_with_index do |talent, i|
      args["talent_#{i+1}"] = talent.name
      args["talent_benefit_#{i+1}"] = talent.description
    end

    self.proficiencies.each_with_index do |prof, i|
      args["prof_#{i+1}"] = prof.name
    end

    # check this url for the pdf field names:
    # https://www.webmerge.me/manage/documents?page=edit&step=test&document_id=14785
    # username: alexlockhart7@gmail.com
    # password: dontopenthecrypt
    args
  end

end
