module ItemsHelper
  def item_stats view
    if ["normal", "", nil].include? view
      [ [ "Cost"               , "buy_cost"   ],
        [ "Weight"             , "weight"     ],
        [ "High Availability"  , "high_avail" ],
        [ "Medium Availability", "med_avail"  ],
        [ "Low Availability"   , "low_avail"  ]  ]
    elsif view == "market"
      [ [ "Cost"               , "buy_cost"   ],
        [ "Weight"             , "weight"     ],
        [ "High Availability"  , "high_avail" ],
        [ "Medium Availability", "med_avail"  ],
        [ "Low Availability"   , "low_avail"  ]  ]
    elsif view == "melee"
      [ [ "Required Strength"  , "str_required"  ],
        [ "Skill Level"        , "skill_level"   ],
        [ "Damage"             , "damage"        ],
        [ "Shield Damage"      , "shield_damage" ],
        [ "Speed"              , "attack_speed"  ],
        [ "Jab Speed"          , "jab_speed"     ],
        [ "Size"               , "size"          ],
        [ "Reach"              , "reach"         ],
        [ "Type"               , "damage_type"   ]  ]
    elsif view == "ranged"
      [ [ "Required Strength"  , "str_required"  ],
        [ "Skill Level"        , "skill_level"   ],
        [ "Damage"             , "damage"        ],
        [ "Shield Damage"      , "shield_damage" ],
        [ "Base Rate of Fire"  , "attack_speed"  ],
        [ "Size"               , "size"          ],
        [ "Max Range"          , "max_range"     ],
        [ "Type"               , "damage_type"   ]  ]
    elsif view == "polearm"
      [ [ "Required Strength"  , "str_required"     ],
        [ "Skill Level"        , "skill_level"      ],
        [ "Size"               , "size"             ],
        [ "Reach"              , "reach"            ],
        [ "Speed"              , "attack_speed"     ],
        [ "Damage"             , "damage"           ],
        [ "Shield Damage"      , "shield_damage"    ],
        [ "Dismount?"          , "dismount"         ],
        [ "Hvy Armor"          , "hvy_armor"        ],
        [ "Set 4 Charge"       , "set_for_charge"   ],
        [ "Jab Speed"          , "jab_speed"        ],
        [ "Defense"            , "pole_arm_defense" ],
        [ "Type"               , "damage_type"      ],
        [ "Phalanx"            , "phalanx"          ]  ]
 
    end
  end
  
  def item_groups view = ""
    if ["normal", "", nil].include? view
      [ "melee", "polearm", "ranged", "armor", "shield", "consumable", "wearable", "precious", "loadbearing", "containers", "misc", "food", "lodging", "services", "transport", "religious", "illumination", "expedition gear", "tools", "scribe materials", "musical instruments", "spice and herbs", "beverages / alcohol", "livestock", "tack and harness" ]
    elsif view == "market"
      [ "melee", "polearm", "ranged", "armor", "shield", "consumable", "wearable", "precious", "loadbearing", "containers", "misc", "food", "lodging", "services", "transport", "religious", "illumination", "expedition gear", "tools", "scribe materials", "musical instruments", "spice and herbs", "beverages / alcohol", "livestock", "tack and harness" ]
    elsif view == "melee"
      [ "melee" ]
    elsif view == "ranged"
      [ "ranged" ]
    elsif view == "polearm"
      [ "polearm" ]
    end
  end

  def item_views
    [ ["All", "market"], [ "Melee", "melee" ], [ "Ranged", "ranged" ], [ "Polearm", "polearm" ] ] 
  end

  def item_types
    [ ["Armor", "armor"], ["Melee", "melee"], ["Ranged", "ranged"], ["Pole Arm", "polearm"], ["Shield", "shield"], ["Consumable", "consumable"], ["Wearable", "wearable"], ["Precious", "precious"],  ["Load Bearing", "loadbearing"], ["Containers", "containers"], ["Misc", "misc"], ["Food", "food"], ["Lodging", "lodging"], ["Services", "services"], ["Transport", "transport"], ["Religious", "religious"], ["Illumination", "illumination"], ["Expedition Gear", "expedition gear"], ["Tools", "tools"], ["Scribe Materials", "scribe materials"], ["Musical Instruments", "musical instruments"], ["Spice and Herbs", "spice and herbs"], ["Beverages / Alcohol", "Beverages / Alcohol"], ["Livestock", "livestock"], ["Tack and Harness", "tack and harness"] ]
  end

  def shield_sizes
    [ ["Buckler", "buckler"], ["Small", "small"], ["Medium", "medium"], ["Large", "large"], ["Body", "body" ] ]
  end

  def armor_types
    [ ["None", "none"], ["Light", "light"], ["Medium", "medium"], ["Heavy", "heavy"] ]
  end

  def locations
    [ ["Arm", "arm"], ["Body", "body"], ["Head", "head"], ["Finger", "finger"], ["Legs", "legs"], ["Feet", "feet"], ["Back", "back"] ]
  end

  def damage_types
    [ ["Hacking", "hacking"], ["Piercing", "piercing"], ["Slashing", "slashing"], ["Crushing", "crushing"] ]
  end

  def size_types
    [ ["T", "t"], ["S", "s"], ["M", "m"], ["L", "l"], ["H", "h"], ["G", "g"], ["E", "e"], ["C", "c"] ]
  end

  def skill_types
    [ ["Minimal", "minimal"], ["Low", "low"], ["Medium", "medium"], ["High", "high"] ]
  end

  def melee_specialization_options
    options = [ ]
    Item.melee_specializations.each do |name|
      options << [ name.titleize, name ]
    end
    options
  end

  def ranged_specialization_options
    options = [ ]
    Item.ranged_specializations.each do |name|
      options << [ name.titleize, name ]
    end
    options
  end

  def item_specialization_options item
    if item.item_type == "ranged"
      ranged_specialization_options
    else
      melee_specialization_options
    end
  end
end
