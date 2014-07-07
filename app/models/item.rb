class Item < ActiveRecord::Base
  has_and_belongs_to_many :characters
  has_many    :talents # these talents require this item to be used
  belongs_to  :proficiency # this is the proficiency needed for this item

  def magic?
    if self.magic_level > 5
      true
    else
      false
    end
  end

end
