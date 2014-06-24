namespace :ability_scores do
  
  task transfer: :environment do
    AbilityScore.all.each do |score|
      min = score.value_range.first
      max = score.value_range.last
      score.min = min
      score.max = max
      score.save
    end
  end

end
