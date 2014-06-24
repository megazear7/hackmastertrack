class AbilityScore < ActiveRecord::Base
  serialize :value_range

  def self.find_ability ability, value
    where(ability: ability).each do |ability_score|
      return ability_score if ability_score.value_range.cover? value
    end
    nil
  end

  def self.find_ability_mod ability, value, mod
    where(ability: ability).each do |ability_score|
      return ability_score.send(mod) if ability_score.value_range.cover? value
    end
    0
  end

end
