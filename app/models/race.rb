class Race < ActiveRecord::Base
  has_many :bp_cost_by_race_classes
  has_and_belongs_to_many :talents
  has_and_belongs_to_many :proficiencies

  def hit_points
    if self.name == "Dwarf"
      10
    else
      { "s" => 5,
        "m" => 10
      }[self.size]
    end
  end

  def self.find_mod race, mod
    where(name: race).each do |thisrace|
      # TODO query the database instead of looping
      mod_val = thisrace.send(mod)
      if mod_val.nil?
        return 0
      else
        return mod_val
      end
    end
    0
  end
end
