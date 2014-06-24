class AbilityScore < ActiveRecord::Base
  serialize :value_range

  def self.find_ability ability, value
    where(ability: ability).each do |ability_score|
      return ability_score if ability_score.value_range.cover? value
    end
    nil
  end

end
