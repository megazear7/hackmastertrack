class ClassSpellbook < ActiveRecord::Base
  belongs_to :spell
  belongs_to :character_class
end
