module ItemsHelper

  def item_views
    [ ["Normal Stats", "normal"], ["Market Stats", "market"], ["Magic Stats", "magic"] ] 
  end

  def item_types
    [ ["Armor", "armor"], ["Melee", "melee"], ["Ranged", "ranged"], ["Pole Arm", "polearm"], ["Shield", "shield"], ["Consumable", "consumable"], ["Wearable", "wearable"], ["Precious", "precious"] ]
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
