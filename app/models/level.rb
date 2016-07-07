class Level < ActiveRecord::Base
  belongs_to :character_class

  def self.find_mod class_id, character_level, mod
    mod_val = 0
    where(character_class_id: class_id).each do |level|
      if level.level_value == character_level
        mod_val = level.send(mod)
      end
    end
    if mod_val.nil?
      0
    else
      mod_val
    end
  end
end
