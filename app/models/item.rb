class Item < ActiveRecord::Base
  has_and_belongs_to_many :characters
  has_many    :talents # these talents require this item to be used
  belongs_to  :proficiency # this is the proficiency needed for this item
  has_one :item_instance
  scope :weapons, -> { where("item_type = 'melee' OR item_type = 'ranged' OR item_type = 'polearm'") }
  scope :magic_items, -> { where("magic_level > 5") }
  scope :non_magic_items, -> { where("magic_level < 5") }
  scope :normal_items, -> { where("magic_level = 0") }

  include Solr

  def solrJson
    title = self.name ? solrSanitize(self.name) : ""
    description = self.description ? solrSanitize(self.description) : ""
    category1 = "item"
    category2 = self.item_type ? solrSanitize(self.item_type) : ""
    category3 = self.damage_type ? solrSanitize(self.damage_type) : ""
    category4 = self.armor_type ? solrSanitize(self.armor_type) : ""

    content = []
    content.push("two handed") if self.two_handed
    content.push("mounted") if self.mounted
    content.push("sword") if self.sword
    content.push("phalanx") if self.phalanx
    content.push("heavy armor") if self.heavy_armor
    content.push(solrSanitize(self.shield_size) + "shield") if self.shield_size
    content.push(solrSanitize(self.location)) if self.location
    

    return JSON.generate({
        id: "/items/" + self.id.to_s,
        path: "/items/" + self.id.to_s,
        title: title,
        description: description,
        category1: category1,
        category2: category2,
        category3: category3,
        category4: category4,
        content: content })
  end

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

  def shield?
    item_type == "shield"
  end

  def melee?
    item_type == "melee"
  end

  def ranged?
    item_type == "ranged"
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

  def shield_penalty
    # The penalty for using a shield but not having the proficiency
    -1 * defense_mod
  end
end
