module ItemsHelper

  def item_views
    [ ["Normal Stats", "normal"], ["Market Stats", "market"], ["Magic Stats", "magic"] ] 
  end

  def item_types
    [ ["Armor", "armor"], ["Weapon", "weapon"], ["Shield", "shield"], ["Consumable", "consumable"], ["Wearable", "wearable"], ["Precious", "precious"] ]
  end

  def shield_sizes
    [ ["Small", "small"], ["Medium", "medium"], ["Large", "large"] ]
  end

  def armor_types
    [ ["Light", "light"], ["Medium", "medium"], ["Heavy", "heavy"] ]
  end

  def locations
    [ ["Arm", "arm"], ["Body", "body"], ["Head", "head"], ["Finger", "finger"], ["Legs", "legs"], ["Feet", "feet"], ["Back", "back"] ]
  end

  def damage_types
    [ ["Hacking", "hacking"], ["Piercing", "piercing"], ["Slashing", "slashing"], ["Crushing", "crushing"] ]
  end

end
