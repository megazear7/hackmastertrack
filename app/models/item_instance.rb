class ItemInstance < ActiveRecord::Base
  belongs_to :item
  belongs_to :character

  def equiped?
    character.left_hand_item == self or character.right_hand_item == self or character.body_item == self
  end

  def magic?
    if self.magic_level and self.magic_level >= 6
      true
    else
      false
    end
  end

  def masterwork?
    if self.magic_level and self.magic_level > 0 and self.magic_level < 6
      true
    else
      false
    end
  end

  def magic_or_masterwork?
    self.magic? or self.masterwork?
  end

  def actual_name
    if self.name.present?
      self.name
    elsif not self.item.nil?
      self.item.name
    else
      ""
    end
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
