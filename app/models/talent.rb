class Talent < ActiveRecord::Base
  has_and_belongs_to_many :characters
  belongs_to :item # this is the item required to benefit from this talent

  def requires_item?
    if self.item.nil?
      false
    else
      true
    end
  end

end
