class Talent < ActiveRecord::Base
  has_and_belongs_to_many :characters
  has_many :character_talents

  def item_options
    # I assume that only melee, ranged and polearm items ever get talents specific
    # to them, this assumption may not hold at all times.
    Item.where(item_type: ["melee", "ranged", "polearm"])
  end
end
