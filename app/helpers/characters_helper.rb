module CharactersHelper

  def extra_bp_options
    [ ["Keep as rolled", "50"], ["Swap two scores", "25"], ["Rearrange as desired", "0"] ]
  end
  
  def hair_options
    [ ["Brown", "brown"], ["Blue", "blue"], ["Hazel", "hazel"], ["Grey", "grey"], ["Black", "black"],
      ["Purple", "purple"], ["Red", "red"], ["Green", "green"], ["Orange", "orange"], ["Teal", "teal"], ["Pink", "pink"] ]
  end
  
  def eye_options

    [ ["Brown", "brown"], ["Blue", "blue"], ["Hazel", "hazel"], ["Grey", "grey"], ["Black", "black"],
      ["Purple", "purple"], ["Red", "red"], ["Green", "green"], ["Orange", "orange"], ["Teal", "teal"], ["Pink", "pink"] ]
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

  def rose_stats
     {"speed" => "Speed",
      "init" => "Initiative",
      "reach" => "Reach",
      "top_save" => "TOP Save",
      "attack" => "Attack",
      "defense" => "Defense",
      "damage_mod" => "Damage",
      "damage_reduction" => "Dmg Red",
      "shield_reduction" => ""}
  end
end
