module CharactersHelper

  def extra_bp_options
    [ ["Keep as rolled (+50)", "50"], ["Swap two scores (+25)", "25"], ["Rearrange as desired (+0)", "0"] ]
  end
  
  def hair_options
    [ "black", "brown", "blond", "blonde", "red", "grey", "white", "bald", "green", "blue", "orange", "pink" ]
  end
  
  def eye_options
    [ "brown", "blue", "hazel", "grey", "black", "purple", "red", "green", "orange", "teal", "pink" ]
  end

  def handedness_options
    [ ["Left", "L"], ["Right", "R"], ["Ambidextrerous", "A"] ]
  end

  def sex_options
    [ ["Male", "M"], ["Female", "F"] ]
  end

  def alignment_options
    [ ["Lawful Good", "LG"], ["Neutral Good", "NG"], ["Chaotic Good", "CG"], ["Lawful Neutral", "LN"], ["True Neutral", "TN"], ["Chaotic Neutral", "CN"], ["Lawful Evil", "LE"], ["Neutral Evil", "NE"], ["Chaotic Evil", "CE"] ]
  end

end
