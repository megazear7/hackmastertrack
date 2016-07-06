class CharactersTalent < ActiveRecord::Base
  belongs_to :character
  belongs_to :talent
  belongs_to :item

  def name
    if talent.item_specific
      talent.name + " (" + item.name + ")"
    else
      talent.name
    end
  end
end
