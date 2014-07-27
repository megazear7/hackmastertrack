module SpellsHelper

  def spell_types
    [ "cleric", "mage" ]
  end

  def saving_throw_types
    [ "none", "physical", "mental", "dodge" ]
  end

  def saving_throw_result_types
    [ "negates", "for half damage" ]
  end

  def volume_of_effect_types
    [ "personal", "creature", "individual", "target", "cubic feet", "square foot", "foot radius", "rectangle", "cone", "bolt", "sphere", "cylinder", "square foot", "individuals within earshot" ]
  end

  def damage_types
    [ "cold", "fire", "water", "impact", "acid", "poison", "charm", "energy", "positive energy", "negative energy", "mental control" ]
  end

end
