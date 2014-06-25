module ItemsHelper

  def item_types
    [ "armor", "weapon", "shield", "consumable", "wearable", "precious" ]
  end

  def shield_sizes
    [ "small", "medium", "large" ]
  end

  def armor_types
    [ "light", "medium", "heavy" ]
  end

  def locations
    [ "left_arm", "right_arm", "body", "head", "finger", "legs", "feet", "back" ]
  end

  def damage_types
    [ "piercing", "slashing", "crushing" ]
  end

end
