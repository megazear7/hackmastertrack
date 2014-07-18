class ItemInstance < ActiveRecord::Base
  belongs_to :item
  belongs_to :character
end
