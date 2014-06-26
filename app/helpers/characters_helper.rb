module CharactersHelper

  def extra_bp_options
    [ ["Keep as rolled (+50)", "50"], ["Swap two scores (+25)", "25"], ["Rearrange as desired (+0)", "0"] ]
  end
  
  def handedness_options
    [ "left", "right", "ambidextrious" ]
  end

  def sex_options
    [ "male", " female" ]
  end

  def alignment_options
    [ "lawful good", "neutral good", "chaotic good", "lawful neutral", "true neutral", "chaotic neutral", "lawful evil", "neutral evil", "chaotic evil" ]
  end

end
