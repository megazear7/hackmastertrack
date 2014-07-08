module ProficienciesHelper
  def prof_list
    list =      Item.where(item_type: "melee").pluck(:name, :skill_level).map {|n, s| n + " (" + (s ? s.titleize : "-") + ")"}
    list =      Item.where(item_type: "ranged").pluck(:name, :skill_level).map {|n, s| n + " (" + (s ? s.titleize : "-") + ")"}
    list =      Item.where(item_type: "polearm").pluck(:name, :skill_level).map {|n, s| n + " (" + (s ? s.titleize : "-") + ")"}
    list.concat Item.where(item_type: "armor").pluck(:name, :armor_type).map   {|n, s| n + " (" + (s ? s.titleize : "-") + ")"}
    list.concat Item.where(item_type: "shield").pluck(:name, :shield_size).map {|n, s| n + " (" + (s ? s.titleize : "-") + ")"}
    list
  end
end
