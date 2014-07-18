class Level < ActiveRecord::Base
  belongs_to :character_class

  def self.find_mod theclass, level, mod
    where(character_class_id: theclass).each do |ability_score|
      # TODO query the database instead of looping
      if ability_score.level_value == level
        mod_val = ability_score.send(mod)
        if mod_val.nil?
          return 0
        else
          return mod_val
        end
      end
    end
    0
  end

end
