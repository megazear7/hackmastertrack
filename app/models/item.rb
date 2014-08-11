class Item < ActiveRecord::Base
  has_and_belongs_to_many :characters
  has_many    :talents # these talents require this item to be used
  belongs_to  :proficiency # this is the proficiency needed for this item
  has_one :item_instance
  scope :weapons, -> { where("item_type = 'melee' OR item_type = 'ranged' OR item_type = 'polearm'") }
  scope :magic_items, -> { where("magic_level > 5") }
  scope :non_magic_items, -> { where("magic_level < 5") }
  scope :normal_items, -> { where("magic_level = 0") }

  def magic?
    if self.magic_level > 5
      true
    else
      false
    end
  end

end
