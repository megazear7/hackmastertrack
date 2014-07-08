module ProficienciesHelper

  def prof_list
    list =      Item.weapons.pluck(:name, :skill_level, :id).map {|n, s, id| [n + " (" + (s ? s.titleize : "-") + ")", id]}
    list.concat Item.where(item_type: "armor").pluck(:name, :armor_type, :id).map   {|n, s, id| [n + " (" + (s ? s.titleize : "-") + ")", id]}
    list.concat Item.where(item_type: "shield").pluck(:name, :shield_size, :id).map {|n, s, id| [n + " (" + (s ? s.titleize : "-") + ")", id]}
    list
  end

  def items_for prof
    formatted = ""
    prof.items.each do |item|
      formatted += item.name + ", "
    end
    formatted[0..-3]
  end

end
