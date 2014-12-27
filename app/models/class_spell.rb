class ClassSpell < ActiveRecord::Base
  belongs_to :character_class
  belongs_to :spell
end
