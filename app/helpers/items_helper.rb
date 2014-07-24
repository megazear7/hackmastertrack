module ItemsHelper
  
  def item_groups
    [ "melee", "polearm", "ranged", "armor", "shield", "consumable", "wearable", "precious", "loadbearing", "containers", "misc", "food", "lodging", "services", "transport", "religious", "illumination", "expedition gear", "tools", "scribe materials", "musical instruments", "spice and herbs", "beverages / alcohol", "livestock", "tack and harness" ]
  end

  def item_views
    [ ["Normal Stats", "normal"], ["Market Stats", "market"], ["Magic Stats", "magic"] ] 
  end

  def item_types
    [ ["Armor", "armor"], ["Melee", "melee"], ["Ranged", "ranged"], ["Pole Arm", "polearm"], ["Shield", "shield"], ["Consumable", "consumable"], ["Wearable", "wearable"], ["Precious", "precious"],  ["Load Bearing", "loadbearing"], ["Containers", "containers"], ["Misc", "misc"], ["Food", "food"], ["Lodging", "lodging"], ["Services", "services"], ["Transport", "transport"], ["Religious", "religious"], ["Illumination", "illumination"], ["Expedition Gear", "expedition gear"], ["Tools", "tools"], ["Scribe Materials", "scribe materials"], ["Musical Instruments", "musical instruments"], ["Spice and Herbs", "spice and herbs"], ["Beverages / Alcohol", "Beverages / Alcohol"], ["Livestock", "livestock"], ["Tack and Harness", "tack and harness"] ]
  end

  def shield_sizes
    [ ["Buckler", "buckler"], ["Small", "small"], ["Medium", "medium"], ["Large", "large"], ["Body", "body" ] ]
  end

  def armor_types
    [ ["None", "none"], ["Light", "light"], ["Medium", "medium"], ["Heavy", "heavy"] ]
  end

  def locations
    [ ["Arm", "arm"], ["Body", "body"], ["Head", "head"], ["Finger", "finger"], ["Legs", "legs"], ["Feet", "feet"], ["Back", "back"] ]
  end

  def damage_types
    [ ["Hacking", "hacking"], ["Piercing", "piercing"], ["Slashing", "slashing"], ["Crushing", "crushing"] ]
  end

  def size_types
    [ ["T", "t"], ["S", "s"], ["M", "m"], ["L", "l"], ["H", "h"], ["G", "g"], ["E", "e"], ["C", "c"] ]
  end

  def skill_types
    [ ["Minimal", "minimal"], ["Low", "low"], ["Medium", "medium"], ["High", "high"] ]
  end

end
