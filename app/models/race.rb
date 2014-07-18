class Race < ActiveRecord::Base
  has_many :bp_cost_by_race_classes

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
