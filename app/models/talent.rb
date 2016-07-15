class Talent < ActiveRecord::Base
  has_and_belongs_to_many :races
  has_many :preferential_races_talents
  has_and_belongs_to_many :preferential_races, :association_foreign_key => "race_id", :join_table => "preferential_races_talents", :class_name => "Race"
  has_and_belongs_to_many :characters
  has_many :character_talents

  def item_options
    # I assume that only melee, ranged and polearm items ever get talents specific
    # to them, this assumption may not hold at all times.
    Item.where(item_type: ["melee", "ranged", "polearm"])
  end

  def adj_bp_cost race
    pref = preferential_races_talents.find_by(race_id: race.id, talent_id: id)
    if not pref.nil?
      return (bp_cost * (pref.percent_cost.to_f/100.to_f)).ceil
    else
      return bp_cost
    end
  end
end
