class AbilityScore < ActiveRecord::Base
  serialize :value_range

  def self.find_ability ability, value
    where(ability: ability).each do |ability_score|
      # TODO query the database instead of looping
      range = ability_score.min..ability_score.max
      return ability_score if range.cover? value
    end
    nil
  end

  def self.find_ability_mod ability, value, mod
    where(ability: ability).each do |ability_score|
      # TODO query the database instead of looping
      range = ability_score.min..ability_score.max
      return ability_score.send(mod) if range.cover? value
    end
    0
  end

end
