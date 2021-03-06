class Character < ActiveRecord::Base
  attr_accessor :item_to_take
  belongs_to :user
  belongs_to :character_class
  belongs_to :race
  has_many :characters_talents
  has_many :talents, through: :characters_talents
  has_and_belongs_to_many :items
  has_and_belongs_to_many :proficiencies
  has_many :characters_skills
  has_many :skills, through: :characters_skills
  has_and_belongs_to_many :campaigns
  belongs_to :left_hand_item, class_name: "ItemInstance", foreign_key: "left_hand_item_id"
  belongs_to :right_hand_item, class_name: "ItemInstance", foreign_key: "right_hand_item_id"
  belongs_to :body_item, class_name: "ItemInstance", foreign_key: "body_item_id"
  has_many :specializations
  has_many :character_spells
  has_many :item_sets
  # the step by step character creation does not allow for this:
  #validates_presence_of :character_class_id, :race_id, :strength, :intelligence, :wisdom, :dexterity, :constitution, :looks, :charisma, :name, :building_points

  has_many :item_instances # these are equiped items

  include Solr

  def solrJson
    userEmail = self.user && self.user.email ? self.user.email : ""
    userId = self.user ? self.user.id.to_s : ""

    content = []
    content.push(solrSanitize(self.alignment_name)) if self.alignment_name
    content.push(solrSanitize(self.gender_name)) if self.gender_name
    content.push(solrSanitize(self.hair + " hair")) if self.hair
    content.push(solrSanitize(self.eyes + " eyes")) if self.eyes
    content.push(solrSanitize(self.race.name)) if self.race and self.race.name
    content.push(solrSanitize(self.character_class.name)) if self.character_class and self.character_class.name

    return JSON.generate({
        path: "/characters/" + self.id.to_s,
        id: self.id.to_s,
        title: solrSanitize(self.name),
        category1: "character",
        category2: userEmail,
        owners: [ userId ],
        groups: [ "admin" ],
        content: content })
  end

  def generate_pdf
    pdftk = PdfForms.new("pdftk")
    pdftk.fill_form "basic_character_sheet.pdf", "character_"+id.to_s+".pdf", pdf_fields
    return "character_"+id.to_s+".pdf"
  end
 
  def one_handed_unequiped_item_instance_location_names equiped_item, location
    item_instances = []
    item_instances << [equiped_item.actual_name, equiped_item.id] if equiped_item
    self.item_instances.each do |item_instance|
      if item_instance.item.location == location and not item_instance.equiped? and item_instance != equiped_item and item_instance.item.two_handed != true
        item_instances << [item_instance.actual_name, item_instance.id]
      end
    end
    item_instances.sort_by!{ |m| m[0].downcase }
  end

  def unequiped_item_instance_location_names equiped_item, location
    item_instances = []
    item_instances << [equiped_item.actual_name, equiped_item.id] if equiped_item
    self.item_instances.each do |item_instance|
      if item_instance.item.location == location and not item_instance.equiped? and item_instance != equiped_item
        item_instances << [item_instance.actual_name, item_instance.id]
      end
    end
    item_instances.sort_by!{ |m| m[0].downcase }
  end

  def item_instance_location_names location
    # this can be done with a join sql query... but I can't figure it out TODO
    item_instances = []
    self.item_instances.each do |item_instance|
      if item_instance.item.location == location
        item_instances << [item_instance.actual_name, item_instance.id]
      end
    end
    item_instances.sort_by!{ |m| m[0].downcase }
  end

  def item_instance_names
    # this can be done with a join sql query... but I can't figure it out TODO
    item_instances = []
    self.item_instances.each do |item_instance|
      item_instances << [item_instance.name, item_instance.id]
    end
    item_instances
  end

  belongs_to :mentor, :class_name => "Character"
  has_many :prodigees, :foreign_key => "mentor_id"

  def add_skill skill, roll
    char_skill = self.characters_skills.find_by(skill_id: skill.id, character_id: self.id)
    if char_skill.nil?
      # set value based on the lowest of the abilities related to the skill, plus the die roll result (i.e. params[:value])
      starting_value = self.attr_value_for(skill) + roll
      char_skill = self.characters_skills.new(skill_id: skill.id, character_id: self.id, value: starting_value)
    else
      char_skill.value += roll
      if char_skill.value > 100
        char_skill.value = 100
      end
    end
    char_skill.save
    return char_skill.value
  end

  def specialized_weapons
    weapons = []
    self.proficiencies.each do |prof|
      prof.items.each do |item|
        if item.is_weapon
          weapons << item
        end
      end
    end
    weapons.sort! do |x,y|
      if specializations_in(x) < specializations_in(y)
        1
      elsif specializations_in(x) > specializations_in(y)
        -1
      else
        0
      end
    end
    weapons
  end

  def specializations_in item
    self.specializations.where(item_id: item.id).count
  end

  def specialization_cost item, stat_name
    spec = self.specializations.find_by(item_id: item.id, stat_name: stat_name)
    base_cost = self.character_class.send(stat_name + "_specialization_cost")
    if spec
      base_cost * (spec.value+1)
    else
      base_cost
    end
  end

  def specialization_available item, stat_name
    lowest_value = 999
 
    # Find the lowest value
    item.specializations.each do |other_stat_name|
      spec = self.specializations.find_by(item: item, stat_name: other_stat_name)
      if spec
        if spec.value < lowest_value
          lowest_value = spec.value
        end
      else
        lowest_value = 0
      end
    end

    # Find the value of this specialization
    spec = self.specializations.find_by(item_id: item.id, stat_name: stat_name)
    if spec
      spec_value = spec.value
    else
      spec_value = 0
    end

    # Return true if this specialization is available to be increased.
    spec_value <= lowest_value
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

  def main_hand_item= item
    self.handedness == "R" ? self.right_hand_item = item : self.left_hand_item = item
  end

  def main_hand_item
    self.handedness == "R" ? self.right_hand_item : self.left_hand_item
  end

  def off_hand_item= item
    self.handedness == "R" ? self.left_hand_item = item : self.right_hand_item = item
  end

  def off_hand_item
    self.handedness == "R" ? self.left_hand_item : self.right_hand_item
  end

  def if_off_hand_shield_is_equiped
    yield off_hand_item if off_hand_item and off_hand_item.item.item_type == "shield"
  end

  def if_main_hand_weapon_is_equiped
    yield main_hand_item if main_hand_item and (main_hand_item.item.item_type == "melee" or main_hand_item.item.item_type == "ranged" or main_hand_item.item.item_type == "polearm")
  end

  def if_armor_is_worn
    yield body_item if body_item
  end

  def calculate_combat_rose equipment = { }
    # calculate all the needed stats, and then return them
    combat_rose = { }
    combat_rose["speed"]            = self.calculate_speed(equipment)
    combat_rose["init"]             = self.calculate_init(equipment)
    combat_rose["init_die_bonus"]   = self.calculate_init_die_bonus(equipment)
    combat_rose["attack"]           = self.calculate_attack(equipment)
    combat_rose["defense"]          = self.calculate_defense(equipment)
    combat_rose["shield_reduction"] = self.calculate_shield_reduction(equipment)
    combat_rose["damage_reduction"] = self.calculate_damage_reduction(equipment)
    combat_rose["damage_mod"]       = self.calculate_damage_mod(equipment)
    combat_rose["reach"]            = self.calculate_reach(equipment)
    combat_rose["top_save"]         = self.calculate_top_save(equipment)
    combat_rose["left_hand"]        = equipment["left_hand"]
    combat_rose["right_hand"]       = equipment["right_hand"]
    combat_rose["body"]             = equipment["body"]
    combat_rose["worn_items"]       = equipment["worn_items"]
    combat_rose
  end

  def calculate_magic_mod equipment, stat
    ret = {}
    equipment.each do |location, itemInstance|
      if location != "worn_items"
        if itemInstance and itemInstance.magic_or_masterwork? and itemInstance.send(stat) and itemInstance.send(stat) != 0
          ret[itemInstance.actual_name + " (Magic)"] = itemInstance.send(stat)
        end
      end
    end
    ret
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

  def alignment_name
    case alignment
    when "LG"
      "Lawful Good"
    when "NG"
      "Neutral Good"
    when "CG"
      "Chaotic Good"
    when "LN"
      "Lawful Neutral"
    when "TN"
      "True Neutral"
    when "CN"
      "Chaotic Neutral"
    when "LE"
      "Lawful Evil"
    when "NE"
      "Neutral Evil"
    when "CE"
      "Chaotic Eveil"
    end
  end

  def gender_name
   case self.sex
   when "M"
     "Male"
   when "F"
     "Female"
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
    if item.shield?
      self.proficiencies.pluck(:id).include?(item.proficiency_id) ? 0 : item.shield_penalty
    else
      self.proficiencies.pluck(:id).include?(item.proficiency_id) ? 0 : item.prof_adjustment
    end
  end

  def calculate_speed equipment
    equipment = build_equipment(equipment)
    ret = {}

    ret.merge!(calculate_magic_mod(equipment, "speed_mod"))

    itemInstance = equipment["#{main_hand}_hand"]
    if itemInstance
      ret["base_weapon_speed"] = itemInstance.item.attack_speed
      characters_talents.each do |char_talent|
        if char_talent.talent.name == "Swift Blade" and char_talent.item.id == itemInstance.item.id and itemInstance.item.melee?
          ret[char_talent.name] = 1
        end
        if char_talent.talent.name == "Greased Lightning" and char_talent.item.id == itemInstance.item.id and itemInstance.item.ranged?
          ret[char_talent.name] = 1
        end
      end
      specialization = self.specializations.find_by(item_id: itemInstance.item.id, stat_name: "speed")
      ret["specialization"] = -1 * specialization.value if specialization and specialization.value != 0
      if itemInstance.item.speed_mod
        ret[itemInstance.actual_name] = itemInstance.item.speed_mod
      end
      if equipment["body"] and equipment["body"].item.speed_mod and equipment["body"].item.speed_mod != 0
        ret[equipment["body"].actual_name] = equipment["body"].item.speed_mod       
      end
      if prof_adjustment(itemInstance.item) != 0
        ret["No " + itemInstance.item.name + " Proficiency"] = -1 * prof_adjustment(itemInstance.item)
      end
      if itemInstance.item.melee?
        level_mod = Level.find_mod(self.character_class.id, self.level, "speed_mod")
        if level_mod and level_mod != 0
            ret["level_bonus"] = level_mod
        end
      elsif itemInstance.item.ranged?
        level_mod = Level.find_mod(self.character_class.id, self.level, "speed_mod")
        if level_mod and level_mod != 0
            ret["level_bonus"] = level_mod
        end
      end
    end

    if equipment["worn_items"]
      equipment["worn_items"].each do |item_instance|
        bonus = item_instance.worn_speed_mod * -1
        if bonus != 0
          ret[item_instance.actual_name + " (Worn)"] = bonus
        end
      end
    end

    mod = 0
    ret.each do |key, val|
      mod += val
    end

    if itemInstance
      if itemInstance.item.size == "l" and mod < 4
        mod = 4
      elsif itemInstance.item.size == "m" and mod < 3
        mod = 3
      elsif itemInstance.item.size == "s" and mod < 2
        mod = 2
      end
    end

    ret["val"] = mod
    ret
  end

  def calculate_init equipment
    equipment = build_equipment(equipment)
    ret = {}

    wisdom_bonus = AbilityScore.find_ability_mod("Wisdom", self.wisdom, "init_mod")
    if wisdom_bonus != 0
      ret["wisdom"] = wisdom_bonus
    end
    dex_bonus = AbilityScore.find_ability_mod("Dexterity", self.dexterity, "init_mod")
    if dex_bonus != 0
      ret["dexterity"] = dex_bonus
    end
    if equipment["#{main_hand}_hand"] and equipment["#{main_hand}_hand"].item.init_mod
      ret[equipment["#{main_hand}_hand"].actual_name] = equipment["#{main_hand}_hand"].item.init_mod
    end
    if equipment["body"] and equipment["body"].item.init_mod and equipment["body"].item.init_mod != 0
      ret[equipment["body"].actual_name] = equipment["body"].item.init_mod
    end
    ret.merge!(calculate_magic_mod(equipment, "init_mod"))

    level_mod = Level.find_mod(self.character_class.id, self.level, "init_mod")
    if level_mod and level_mod != 0
        ret["level_bonus"] = level_mod
    end

    if equipment["worn_items"]
      equipment["worn_items"].each do |item_instance|
        bonus = item_instance.worn_init_mod * -1
        if bonus != 0
          ret[item_instance.actual_name + " (Worn)"] = bonus
        end
      end
    end

    mod = 0
    ret.each do |key, val|
      mod += val
    end
    ret["val"] = mod
    ret
  end

  def calculate_init_die_bonus equipment
    equipment = build_equipment(equipment)
    ret = {}
 
    if Race.find_mod(self.race.name, "init_die_bonus")
      ret[self.race.name] = 1
    end

    if equipment["worn_items"]
      equipment["worn_items"].each do |item_instance|
        bonus = item_instance.worn_init_die_mod
        if bonus != 0
          ret[item_instance.actual_name + " (Worn)"] = bonus
        end
      end
    end

    characters_talents.each do |char_talent|
      if char_talent.talent.name == "Improved Awareness"
        ret[char_talent.name] = 1
      end
    end

    level_mod = Level.find_mod(self.character_class.id, self.level, "init_die_mod")
    if level_mod and level_mod != 0
        ret["level_bonus"] = level_mod
    end

    ret.merge!(calculate_magic_mod(equipment, "init_die_mod"))

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

    int_mod = AbilityScore.find_ability_mod("Intelligence", self.intelligence, "attack_mod")
    if int_mod != 0
      ret["intelligence"] = int_mod
    end
    dex_mod = AbilityScore.find_ability_mod("Dexterity", self.dexterity, "attack_mod")
    if dex_mod != 0
      ret["dexterity"] = dex_mod
    end

    itemInstance = equipment["#{main_hand}_hand"]
    if itemInstance
      characters_talents.each do |char_talent|
        if char_talent.talent.name == "Attack Bonus" and char_talent.item.id == itemInstance.item.id and itemInstance.item.melee?
          ret[char_talent.name] = 1
        end
        if char_talent.talent.name == "Crack Shot" and char_talent.item.id == itemInstance.item.id and itemInstance.item.ranged?
          ret[char_talent.name] = 1
        end
      end
      specialization = self.specializations.find_by(item_id: itemInstance.item.id, stat_name: "attack")
      ret["specialization"] = specialization.value if specialization
      if itemInstance.item.attack_mod
        ret[itemInstance.actual_name] = itemInstance.item.attack_mod
      end
      if prof_adjustment(itemInstance.item) != 0
        ret["No " + itemInstance.item.name + " Proficiency"] = prof_adjustment(itemInstance.item) 
      end
    end

    if equipment["body"] and equipment["body"].item.attack_mod
      ret[equipment["body"].actual_name] = equipment["body"].item.attack_mod       
    end   

    level_mod = Level.find_mod(self.character_class.id, self.level, "attack_mod")
    if level_mod and level_mod != 0
        ret["level_bonus"] = level_mod
    end

    if equipment["worn_items"]
      equipment["worn_items"].each do |item_instance|
        bonus = item_instance.worn_attack_mod
        if bonus != 0
          ret[item_instance.actual_name + " (Worn)"] = bonus
        end
      end
    end

    ret.merge!(calculate_magic_mod(equipment, "attack_mod"))

    mod = 0
    ret.each do |key, val|
      mod += val
    end
    ret["val"] = mod
    ret
  end

  def has_talent talent
    characters_talents.exists?(talent_id: talent.id)
  end

  def has_prof? prof
    proficiencies.exists?(prof.id)
  end

  def has_spell? spell
    not character_spells.find_by(spell_id: spell.id).nil?
  end

  def max_skill_mastery(skill)
    # TODO: Look at characters stats to determine the skill mastery
    5
  end

  def die_size(skill)
    value = value_with(skill)
    if value < 25
      12
    elsif value < 35
      10
    elsif value < 75
      8
    elsif value < 90
      6
    else
      4
    end 
  end

  def has_skill(skill)
    characters_skills.exists?(skill_id: skill.id)
  end

  def value_with(skill)
    if characters_skills.exists?(skill_id: skill.id)
      characters_skills.find_by(skill_id: skill.id).value
    else
      0
    end
  end

  def shield_equiped equipment
    if (equipment["#{main_hand}_hand"] and equipment["#{main_hand}_hand"].item.item_type == "shield") or
       (equipment["#{off_hand}_hand"] and equipment["#{off_hand}_hand"].item.item_type == "shield")
      true
    else
      false
    end
  end

  def calculate_defense equipment
    equipment = build_equipment(equipment)
    ret = {}

    characters_talents.each do |char_talent|
      if char_talent.talent.name == "Dodge"
        ret[char_talent.name] = 1
      end
    end

    wis_mod = AbilityScore.find_ability_mod("Wisdom", self.wisdom, "defense_mod")
    if wis_mod != 0
      ret["wisdom"] = wis_mod
    end
    dex_mod = AbilityScore.find_ability_mod("Dexterity", self.dexterity, "defense_mod")
    if dex_mod != 0
      ret["dexterity"] = dex_mod
    end

    itemInstance = equipment["#{main_hand}_hand"]
    if itemInstance
      characters_talents.each do |char_talent|
        if char_talent.talent.name == "Parry Bonus" and char_talent.item.id == itemInstance.item.id and itemInstance.item.melee?
          ret[char_talent.name] = 1
        end
      end
      specialization = self.specializations.find_by(item_id: itemInstance.item.id, stat_name: "defense")
      ret["specialization"] = specialization.value if specialization
      characters_talents.each do |char_talent|
        if char_talent.talent.name == "Dodge"
          ret[char_talent.name] = 1
        end
      end

      if itemInstance.item.defense_mod
        ret[itemInstance.actual_name] = itemInstance.item.defense_mod
      end
    end
    if equipment["#{off_hand}_hand"] and equipment["#{off_hand}_hand"].item.defense_mod
      ret[equipment["#{off_hand}_hand"].actual_name] = equipment["#{off_hand}_hand"].item.defense_mod
    end

    if not shield_equiped(equipment)
      ret["no_shield"] = -4
    end
    if equipment["body"] and equipment["body"].item.defense_mod
        ret[equipment["body"].actual_name] = equipment["body"].item.defense_mod
    end

    if equipment["left_hand"] and equipment["left_hand"].item and equipment["left_hand"].item.shield?
        shield = equipment["left_hand"]
        if prof_adjustment(shield.item) != 0
            ret["no_shield_proficiency"] = prof_adjustment(shield.item)
        end
    end

    if equipment["right_hand"] and equipment["right_hand"].item and equipment["right_hand"].item.shield?
      shield = equipment["right_hand"]
      if prof_adjustment(shield.item) != 0
          ret["no_shield_proficiency"] = prof_adjustment(shield.item)
      end
    end

    def_adjustment = Race.find_mod(self.race.name, "defense_adjustment")
    if def_adjustment != 0
        ret[self.race.name] = def_adjustment
    end
    ret.merge!(calculate_magic_mod(equipment, "defense_mod"))

    if equipment["worn_items"]
      equipment["worn_items"].each do |item_instance|
        bonus = item_instance.worn_defense_mod
        if bonus != 0
          ret[item_instance.actual_name + " (Worn)"] = bonus
        end
      end
    end

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

    if equipment["#{off_hand}_hand"]
      shield = equipment["#{off_hand}_hand"]

      ret[shield.actual_name + " Magic"] = shield.shield_damage_reduction if shield.shield_damage_reduction

      if shield.item.shield_size
        case shield.item.shield_size
        when "buckler"
          ret[shield.actual_name] = 4
        when "small"
          ret[shield.actual_name] = 4
        when "medium"
          ret[shield.actual_name] = 6
        when "large"
          ret[shield.actual_name] = 6
        when "body"
          ret[shield.actual_name] = 6
        end
      end
    end

    if equipment["worn_items"]
      equipment["worn_items"].each do |item_instance|
        bonus = item_instance.worn_shield_damage_reduction
        if bonus != 0
          ret[item_instance.actual_name + " (Worn)"] = bonus
        end
      end
    end

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

    characters_talents.each do |char_talent|
      if char_talent.talent.name == "Tough Hide"
        ret[char_talent.name] = 1
      end
    end

    if equipment["body"] and equipment["body"].item.damage_reduction
      ret[equipment["body"].actual_name] = equipment["body"].item.damage_reduction       
    end
    ret.merge!(calculate_magic_mod(equipment, "damage_reduction"))

    if equipment["worn_items"]
      equipment["worn_items"].each do |item_instance|
        bonus = item_instance.worn_damage_reduction
        if bonus != 0
          ret[item_instance.actual_name + " (Worn)"] = bonus
        end
      end
    end

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

    itemInstance = equipment["#{main_hand}_hand"]
    str_mod = AbilityScore.find_ability_mod("Strength", self.strength, "damage_mod")
    if str_mod != 0
      ret["strength"] = str_mod
    end
    if itemInstance
      characters_talents.each do |char_talent|
        if char_talent.talent.name == "Damage Bonus" and char_talent.item.id == itemInstance.item.id and itemInstance.item.melee?
          ret[char_talent.name] = 1
        end
      end
      specialization = self.specializations.find_by(item_id: itemInstance.item.id, stat_name: "damage")
      ret["specialization"] = specialization.value if specialization
      if itemInstance.item.damage_mod
        ret[itemInstance.actual_name] = itemInstance.item.damage_mod
      end
      if equipment["body"] and equipment["body"].item.damage_mod != 0
        ret[equipment["body"].actual_name] = equipment["body"].item.damage_mod
      end
      if prof_adjustment(itemInstance.item) != 0
        ret["No " + itemInstance.item.name + " Proficiency"] = prof_adjustment(itemInstance.item)
      end
    end
    ret.merge!(calculate_magic_mod(equipment, "damage_mod"))

    if equipment["worn_items"]
      equipment["worn_items"].each do |item_instance|
        bonus = item_instance.worn_damage_mod
        if bonus != 0
          ret[item_instance.actual_name + " (Worn)"] = bonus
        end
      end
    end

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
    if equipment["#{main_hand}_hand"]
      characters_talents.each do |char_talent|
        if char_talent.talent.name == "Improved Reach" and char_talent.item.id == equipment["#{main_hand}_hand"].item.id and equipment["#{main_hand}_hand"].item.melee?
          ret[char_talent.name] = 1
        end
      end
    end
    if equipment["#{main_hand}_hand"] and equipment["#{main_hand}_hand"].item.reach
      ret[equipment["#{main_hand}_hand"].actual_name] = equipment["#{main_hand}_hand"].item.reach 
    end
    mod = 0
    ret.each do |key, val|
      mod += val
    end
    ret["val"] = mod
    ret
  end

  def value_for_attr attr_str
    case attr_str
    when "str"
      strength.floor
    when "int"
      intelligence.floor
    when "wis"
      wisdom.floor
    when "dex"
      dexterity.floor
    when "con"
      constitution.floor
    when "cha"
      charisma.floor
    when "lks"
      looks.floor
    else
      999
    end
  end

  def attr_value_for skill
    [value_for_attr(skill.main_attr),
     value_for_attr(skill.other_attr),
     value_for_attr(skill.third_attr)].min
  end

  def calculate_top_save equipment
    equipment = build_equipment(equipment)
    ret = {}
    ret["constitution"] = (self.constitution / 2).floor
    mod = 0
    ret.each do |key, val|
      mod += val
    end
    ret["val"] = mod
    ret
  end

  def spell_points_this_level
    Level.find_mod(self.character_class.id, self.level, "spell_points")
  end

  def magic_user?
    # TODO: What about clerics?
    has_spell_points
  end

  def has_spell_points
    Level.find_mod(self.character_class.id, self.level, "spell_points") > 0
  end

  def luck_points_this_level
    character_class.luck_points + level - 1
  end

  def has_luck_points
    points = character_class.luck_points
    if points.nil?
      false
    else
      points > 0
    end
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
    when 14150..17599
      10
    when 17600..21649
      11
    when 21650..26399
      12
    when 26400..31949
      13
    when 31950..38399
      14
    when 38400..45849
      15
    when 45850..54399
      16
    when 54400..64149
      17
    when 64150..75199
      18
    when 75200..87649
      19
    when 87650..99999
      20
    end
  end

  def needs_to_level
    if self.level < self.actual_level
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

  def has_specialization itemInstance, spec, val
    self.specializations.find_by(item_id: itemInstance.item.id, stat_name: spec) and self.specializations.find_by(item_id: itemInstance.item.id, stat_name: spec).value >= val
  end

  def pdf_fields
    args = {} 
    args["name"] = self.name
    args["class"] = self.character_class.name
    args["race"] = self.race.name
    args["level"] = self.level
    args["alignment"] = self.alignment
    args["sex"] = self.sex
    args["age"] = self.age
    args["height"] = self.height
    args["weight"] = self.weight
    args["hair"] = self.hair
    args["eyes"] = self.eyes
    args["handedness"] = self.handedness
    #args["patron_gods"] = self.patron_gods.name if self.patron_gods
    #args["anointed_y"] = "X" if self.anointed == "Yes"
    #args["anointed_n"] = "X" if self.anointed == "No"
    args["building_points"] = self.building_points
    args["experience"] = self.exp
    args["hit_points"] = self.health

    # Combat Rose Character sheet doesn't have a combat rose yet
    equipment = {}
    equipment["left_hand"] = left_hand_item
    equipment["right_hand"] = right_hand_item
    equipment["body"] = body_item
    rose = calculate_combat_rose equipment
    #args["shield_defense_bonus"] = self.  if self.
    #args[" shield_damage_reduction "] = self.  if self.
    #args["fatigue_factor"] = self.  if self.
    #args["threshold_of_pain"] = self.  if self.
    #args["previous_hit_point_roll"] = self.  if self.  
    # body_equiped
    # shield_equiped
    # body_equiped_damage_reduction

    # Money
    args["trade_coins"] = self.trade_coins
    args["cp"] = self.copper
    args["sp"] = self.silver
    args["gp"] = self.gold

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
    args["str_percent"] =  fract_extract self.strength
    args["feat_of_strength"] = plusinfront AbilityScore.find_ability_mod("Strength", self.strength, "feat_of_strength")
    args["str_damage_mod"] = plusinfront AbilityScore.find_ability_mod("Strength", self.strength, "damage_mod")
    args["str_lift"] =  AbilityScore.find_ability_mod("Strength", self.strength, "lift")
    args["str_carry"] = AbilityScore.find_ability_mod("Strength", self.strength, "carry")
    args["str_drag"] =  AbilityScore.find_ability_mod("Strength", self.strength, "drag")

    # Intelligence
    args["int"] = self.intelligence.to_i
    args["int_percent"] = fract_extract self.intelligence
    args["int_attack_mod"] = plusinfront AbilityScore.find_ability_mod("Intelligence", self.intelligence, "attack_mod")

    # Wisdom
    args["wis"] = self.wisdom.to_i
    args["wis_percent"] = fract_extract self.wisdom
    args["wis_init_mod"] = plusinfront AbilityScore.find_ability_mod("Wisdom", self.wisdom, "init_mod")
    args["mental_saving_throw_bonus"] = plusinfront AbilityScore.find_ability_mod("Wisdom", self.wisdom, "mental_saving_throw_bonus")
    args["wis_defense_mod"] = plusinfront AbilityScore.find_ability_mod("Wisdom", self.wisdom, "defense_mod")

    # Dexterity
    args["dex"] = self.dexterity.to_i
    args["dex_percent"] = fract_extract self.dexterity
    args["des_attack_mod"] = plusinfront AbilityScore.find_ability_mod("Dexterity", self.dexterity, "attack_mod")
    args["des_init_mod"] = plusinfront AbilityScore.find_ability_mod("Dexterity", self.dexterity, "init_mod")
    args["dex_defense_mod"] = plusinfront AbilityScore.find_ability_mod("Dexterity", self.dexterity, "defense_mod")
    args["dodge_saving_throw_bonus"] = plusinfront AbilityScore.find_ability_mod("Dexterity", self.dexterity, "dodge_saving_throw_bonus")
    args["feat_of_agility"] = AbilityScore.find_ability_mod("Dexterity", self.dexterity, "feat_of_agility")
    args["physical_saving_throw_bonus"] = plusinfront AbilityScore.find_ability_mod("Dexterity", self.dexterity, "physical_saving_throw_bonus")

    # Constitituion
    args["con"] = self.constitution.to_i
    args["con_percent"] = fract_extract self.constitution

    # Looks
    args["lks"] = self.looks.to_i
    args["lks_percent"] = fract_extract self.looks

    # Charisma
    args["cha"] = self.charisma.to_i
    args["cha_percent"] = fract_extract self.charisma
    args["turning_mod"] = plusinfront AbilityScore.find_ability_mod("Charisma", self.charisma, "turning_mod")
    args["morale_mod"] = plusinfront AbilityScore.find_ability_mod("Charisma", self.charisma, "morale_mod")

    # Armor worn
    self.if_armor_is_worn do |armor|
      args["body_equiped"] = armor.actual_name
      args["body_equiped_damage_reduction"] = armor.item.damage_reduction
    end
    self.if_off_hand_shield_is_equiped do |shield|
      args["shield_equiped"] = shield.actual_name
      args["shield_defense_bonus"] = shield.shield_defense
      args["shield_damage_reduction"] = shield.item.damage_reduction
    end

    args["profile_1_notes"] = ""
    self.if_main_hand_weapon_is_equiped do |weapon|
      args["combat_profile_weapon_1"] = weapon.actual_name
    end

    # Profile 1 Level mods.
    attack_level_mod = Level.find_mod(self.character_class.id, self.level, "attack_mod")
    args["profile_1_level_attack"] = attack_level_mod != 0 ? plusinfront(attack_level_mod) : "--"

    speed_level_mod = Level.find_mod(self.character_class.id, self.level, "speed_mod")
    args["profile_1_level_speed"] = speed_level_mod != 0 ? plusinfront(speed_level_mod) : "--"

    init_level_mod = Level.find_mod(self.character_class.id, self.level, "init_mod")
    args["profile_1_level_init"] = init_level_mod != 0 ? plusinfront(init_level_mod) : "--"

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
      args["profile_1_specialization_attack"]  = self.specializations.find_by(item_id: self.main_hand_item.item.id, stat_name: "attack") ? (plusinfront self.specializations.find_by(item_id: self.main_hand_item.item.id, stat_name: "attack").value) : "--"
      args["profile_1_specialization_speed"]   = self.specializations.find_by(item_id: self.main_hand_item.item.id, stat_name: "speed")  ? (plusinfront self.specializations.find_by(item_id: self.main_hand_item.item.id, stat_name: "speed").value)  : "--"
      args["profile_1_specialization_init"]    = "--"
      args["profile_1_specialization_defense"] = self.specializations.find_by(item_id: self.main_hand_item.item.id, stat_name: "defense") ? (plusinfront self.specializations.find_by(item_id: self.main_hand_item.item.id, stat_name: "defense").value) : "--"
      args["profile_1_specialization_damage"]  = self.specializations.find_by(item_id: self.main_hand_item.item.id, stat_name: "damage")  ? (plusinfront self.specializations.find_by(item_id: self.main_hand_item.item.id, stat_name: "damage").value)  : "--"
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
    args["profile_1_race_defense"] = plusinfront Race.find_mod(self.race.name, "defense_adjustment")
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
      args["profile_1_shield_defense"] = self.off_hand_item.item.item_type == "shield" ? plusinfront(self.off_hand_item.item.defense_mod) : "--"
    else
      args["profile_1_shield_defense"] = "-4"
    end
    args["profile_1_shield_attack"]  = "--"
    args["profile_1_shield_speed"]   = "--"
    args["profile_1_shield_init"]    = "--"
    args["profile_1_shield_damage"]  = "--"

    # Profile 1 Magic mods.
    args["profile_1_magic_attack"]  = rose["attack"]["magic"] ? plusinfront(rose["attack"]["magic"]) : "--"
    args["profile_1_magic_speed"]   = rose["speed"]["magic"] ? plusinfront(rose["speed"]["magic"]) : "--"
    args["profile_1_magic_init"]    = rose["init"]["magic"] ? plusinfront(rose["init"]["magic"]) : "--"
    args["profile_1_magic_defense"] = rose["defense"]["magic"] ? plusinfront(rose["defense"]["magic"]) : "--"
    args["profile_1_magic_damage"]  = rose["damage_mod"]["magic"] ? plusinfront(rose["damage_mod"]["magic"]) : "--"

    # combat_profile_weapon_1
    args["profile_1_attack"]  = plusinfront rose["attack"]["val"]
    args["profile_1_speed"]   = plusinfront rose["speed"]["val"]
    args["profile_1_init"]    = plusinfront rose["init"]["val"]
    args["profile_1_defense"] = plusinfront rose["defense"]["val"]
    args["profile_1_damage"]  = plusinfront rose["damage_mod"]["val"]
    args["profile_1_reach"]   = rose["reach"]["val"].to_s + " ft"
    self.if_main_hand_weapon_is_equiped do |weapon|
      args["profile_1_base_weapon_speed"]  = weapon.item.attack_speed
      args["profile_1_base_weapon_damage"] = weapon.item.damage
    end

    self.if_main_hand_weapon_is_equiped do |weapon|
      if has_specialization(weapon, "speed", 1)
        args["profile_1_spec_speed_1"] = "X"
      end
      if has_specialization(weapon, "attack", 1)
        args["profile_1_spec_attack_1"] = "X"
      end
      if has_specialization(weapon, "defense", 1)
        args["profile_1_spec_defense_1"] = "X"
      end
      if has_specialization(weapon, "damage", 1)
        args["profile_1_spec_damage_1"] = "X"
      end

      if has_specialization(weapon, "speed", 2)
        args["profile_1_spec_speed_2"] = "X"
      end
      if has_specialization(weapon, "attack", 2)
        args["profile_1_spec_attack_2"] = "X"
      end
      if has_specialization(weapon, "defense", 2)
        args["profile_1_spec_defense_2"] = "X"
      end
      if has_specialization(weapon, "damage", 2)
        args["profile_1_spec_damage_2"] = "X"
      end

      if has_specialization(weapon, "speed", 3)
        args["profile_1_spec_speed_3"] = "X"
      end
      if has_specialization(weapon, "attack", 3)
        args["profile_1_spec_attack_3"] = "X"
      end
      if has_specialization(weapon, "defense", 3)
        args["profile_1_spec_defense_3"] = "X"
      end
      if has_specialization(weapon, "damage", 3)
        args["profile_1_spec_damage_3"] = "X"
      end

      if has_specialization(weapon, "speed", 4)
        args["profile_1_spec_speed_4"] = "X"
      end
      if has_specialization(weapon, "attack", 4)
        args["profile_1_spec_attack_4"] = "X"
      end
      if has_specialization(weapon, "defense", 4)
        args["profile_1_spec_defense_4"] = "X"
      end
      if has_specialization(weapon, "damage", 4)
        args["profile_1_spec_damage_4"] = "X"
      end

      if has_specialization(weapon, "speed", 5)
        args["profile_1_spec_speed_5"] = "X"
      end
      if has_specialization(weapon, "attack", 5)
        args["profile_1_spec_attack_5"] = "X"
      end
      if has_specialization(weapon, "defense", 5)
        args["profile_1_spec_defense_5"] = "X"
      end
      if has_specialization(weapon, "damage", 5)
        args["profile_1_spec_damage_5"] = "X"
      end
    end

    args["profile_1_notes"] += "Initiative die bonus: " + rose["init_die_bonus"]["val"].to_s

    self.item_instances.each_with_index do |item_instance, i|
      if not item_instance.magic_or_masterwork?
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

    self.characters_talents.each_with_index do |char_talent, i|
      args["talent_#{i+1}"] = char_talent.name
      args["talent_benefit_#{i+1}"] = char_talent.talent.description
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
