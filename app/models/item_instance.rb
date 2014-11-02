class ItemInstance < ActiveRecord::Base
  belongs_to :item
  belongs_to :character

  def actual_name
    self.name == "" ? self.item.name : self.name
  end

  def shield_defense
    if self.item.shield_size
      case self.item.shield_size
      when "buckler"
        4
      when "small"
        4
      when "medium"
        6
      when "large"
        6
      when "body"
        6
      end
    end
  end
end
