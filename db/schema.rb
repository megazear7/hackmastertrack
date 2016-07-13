# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160713151959) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ability_scores", force: true do |t|
    t.string   "ability",                     default: ""
    t.text     "value_range",                 default: ""
    t.integer  "feat_of_strength",            default: 0
    t.integer  "lift",                        default: 0
    t.integer  "carry",                       default: 0
    t.integer  "drag",                        default: 0
    t.integer  "damage_mod",                  default: 0
    t.integer  "init_mod",                    default: 0
    t.integer  "speed_mod",                   default: 0
    t.integer  "attack_mod",                  default: 0
    t.integer  "defense_mod",                 default: 0
    t.integer  "turning_mod",                 default: 0
    t.integer  "feat_of_agility",             default: 0
    t.integer  "mental_saving_throw_bonus",   default: 0
    t.integer  "dodge_saving_throw_bonus",    default: 0
    t.integer  "physical_saving_throw_bonus", default: 0
    t.integer  "morale_mod",                  default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "min",                         default: 0.0
    t.float    "max",                         default: 0.0
    t.integer  "max_spells_per_level",        default: 0
    t.integer  "chance_to_learn_spell",       default: 0
  end

  create_table "bp_cost_by_race_classes", force: true do |t|
    t.integer  "character_class_id"
    t.integer  "race_id"
    t.integer  "bp_cost"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "campaigns", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "campaigns_characters", force: true do |t|
    t.integer "campaign_id"
    t.integer "character_id"
  end

  create_table "character_classes", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "hit_dice_size",               default: 0
    t.integer  "attack_specialization_cost",  default: 10
    t.integer  "speed_specialization_cost",   default: 10
    t.integer  "defense_specialization_cost", default: 10
    t.integer  "damage_specialization_cost",  default: 10
    t.integer  "luck_points"
  end

  create_table "character_classes_proficiencies", force: true do |t|
    t.integer "character_class_id"
    t.integer "proficiency_id"
  end

  create_table "character_spells", force: true do |t|
    t.integer  "character_id"
    t.integer  "spell_id"
    t.integer  "level"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "characters", force: true do |t|
    t.float    "strength",           default: 0.0
    t.float    "intelligence",       default: 0.0
    t.float    "wisdom",             default: 0.0
    t.float    "dexterity",          default: 0.0
    t.float    "constitution",       default: 0.0
    t.float    "looks",              default: 0.0
    t.float    "charisma",           default: 0.0
    t.float    "honor",              default: 0.0
    t.float    "fame",               default: 0.0
    t.integer  "building_points",    default: 0
    t.integer  "health",             default: 0
    t.string   "name",               default: ""
    t.integer  "level",              default: 1
    t.string   "alignment",          default: "LG"
    t.string   "sex",                default: "M"
    t.integer  "age",                default: 0
    t.integer  "height",             default: 0
    t.integer  "weight",             default: 0
    t.string   "hair",               default: "black"
    t.string   "eyes",               default: "brown"
    t.string   "handedness",         default: "L"
    t.string   "trade_coins",        default: ""
    t.integer  "copper",             default: 0
    t.integer  "silver",             default: 0
    t.integer  "gold",               default: 0
    t.integer  "spell_points",       default: 0
    t.integer  "luck_points",        default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",            default: 0
    t.integer  "exp",                default: 0
    t.integer  "mentor_id",          default: 0
    t.integer  "left_hand_item_id",  default: 0
    t.integer  "right_hand_item_id", default: 0
    t.integer  "body_item_id",       default: 0
    t.integer  "character_class_id", default: 0
    t.integer  "race_id",            default: 0
    t.boolean  "finished",           default: false
  end

  create_table "characters_items", force: true do |t|
    t.integer "character_id"
    t.integer "item_id"
  end

  create_table "characters_proficiencies", force: true do |t|
    t.integer "character_id"
    t.integer "proficiency_id"
  end

  create_table "characters_skills", force: true do |t|
    t.integer "character_id"
    t.integer "skill_id"
    t.integer "value"
  end

  create_table "characters_talents", force: true do |t|
    t.integer "character_id"
    t.integer "talent_id"
    t.integer "item_id"
  end

  create_table "class_spells", force: true do |t|
    t.integer  "character_class_id"
    t.integer  "spell_id"
    t.integer  "level"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "encounters", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "campaign_id"
  end

  create_table "item_instances", force: true do |t|
    t.integer  "item_id"
    t.integer  "character_id"
    t.integer  "durability",       default: 0
    t.integer  "attack_mod",       default: 0
    t.integer  "speed_mod",        default: 0
    t.integer  "init_mod",         default: 0
    t.integer  "defense_mod",      default: 0
    t.integer  "damage_mod",       default: 0
    t.integer  "damage_reduction", default: 0
    t.integer  "magic_level",      default: 0
    t.integer  "init_die_mod",     default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "display",          default: false
    t.string   "name",             default: ""
  end

  create_table "items", force: true do |t|
    t.integer  "attack_mod",              default: 0
    t.integer  "speed_mod",               default: 0
    t.integer  "init_mod",                default: 0
    t.integer  "defense_mod",             default: 0
    t.integer  "damage_mod",              default: 0
    t.integer  "damage_reduction",        default: 0
    t.integer  "magic_level",             default: 0
    t.float    "weight",                  default: 0.0
    t.integer  "cover_value",             default: 0
    t.string   "location",                default: "arm"
    t.string   "damage",                  default: ""
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "shield_size",             default: ""
    t.string   "armor_type",              default: ""
    t.string   "name",                    default: ""
    t.string   "description",             default: ""
    t.integer  "attack_speed",            default: 0
    t.integer  "jab_speed",               default: 0
    t.float    "reach",                   default: 0.0
    t.float    "buy_cost",                default: 0.0
    t.float    "sell_value",              default: 0.0
    t.string   "damage_type",             default: ""
    t.integer  "heal_value",              default: 0
    t.string   "item_type",               default: ""
    t.integer  "high_avail",              default: 0
    t.integer  "med_avail",               default: 0
    t.integer  "low_avail",               default: 0
    t.integer  "init_die_mod",            default: 0
    t.integer  "movement_rate_reduction", default: 0
    t.integer  "crouching_cover_value",   default: 0
    t.string   "shield_damage",           default: ""
    t.integer  "str_required",            default: 0
    t.string   "skill_level",             default: ""
    t.boolean  "dismount",                default: false
    t.integer  "heavy_armor",             default: 0
    t.boolean  "set_for_charge",          default: false
    t.string   "pole_arm_defense",        default: ""
    t.integer  "phalanx",                 default: 0
    t.string   "size",                    default: ""
    t.integer  "max_range",               default: 0
    t.integer  "range_short",             default: 0
    t.integer  "range_medium",            default: 0
    t.integer  "range_long",              default: 0
    t.integer  "range_maximum",           default: 0
    t.integer  "proficiency_id",          default: 0
    t.boolean  "two_handed",              default: false
    t.boolean  "mounted",                 default: false
    t.boolean  "sword",                   default: false
    t.float    "capacity_pounds",         default: 0.0
    t.float    "capacity_gallons",        default: 0.0
    t.integer  "number_of_days",          default: 0
    t.boolean  "requires_preparation",    default: false
    t.integer  "distance",                default: 0
  end

  create_table "levels", force: true do |t|
    t.integer  "level_value",        default: 0
    t.integer  "init_mod",           default: 0
    t.integer  "attack_mod",         default: 0
    t.integer  "speed_mod",          default: 0
    t.integer  "spell_points",       default: 0
    t.integer  "character_class_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "stvsspells",         default: 0
    t.string   "added_spells",       default: ""
    t.integer  "ranged_speed_mod",   default: 0
    t.integer  "init_die_mod",       default: 0
    t.string   "hit_dice",           default: ""
  end

  create_table "monsters", force: true do |t|
    t.string   "name",                  default: ""
    t.text     "description",           default: ""
    t.text     "combat_and_tactics",    default: ""
    t.text     "habitat_and_society",   default: ""
    t.text     "ecology",               default: ""
    t.text     "attack_description",    default: ""
    t.integer  "health",                default: 0
    t.boolean  "template",              default: false
    t.string   "size",                  default: ""
    t.string   "weight",                default: ""
    t.string   "intelligence",          default: ""
    t.integer  "fatigue_factor",        default: 0
    t.integer  "crawl",                 default: 0
    t.integer  "walk",                  default: 0
    t.integer  "jog",                   default: 0
    t.integer  "run",                   default: 0
    t.integer  "sprint",                default: 0
    t.integer  "physical_save",         default: 0
    t.integer  "mental_save",           default: 0
    t.integer  "dodge_save",            default: 0
    t.string   "activity_cycle",        default: ""
    t.string   "no_appearing",          default: ""
    t.integer  "chance_in_lair",        default: 0
    t.string   "frequency",             default: ""
    t.string   "alignment",             default: ""
    t.string   "vision_type",           default: ""
    t.string   "awareness_and_senses",  default: ""
    t.string   "habitat",               default: ""
    t.string   "diet",                  default: ""
    t.string   "organization",          default: ""
    t.string   "climate",               default: ""
    t.string   "medicinal_yield",       default: ""
    t.string   "spell_component_yield", default: ""
    t.string   "hide_or_trophy",        default: ""
    t.string   "treasure",              default: ""
    t.string   "edible",                default: ""
    t.string   "other_yield",           default: ""
    t.integer  "exp_value",             default: 0
    t.integer  "will_factor",           default: 0
    t.integer  "speed",                 default: 0
    t.integer  "attack",                default: 0
    t.integer  "init",                  default: 0
    t.integer  "defense",               default: 0
    t.integer  "damage_reduction",      default: 0
    t.string   "reach",                 default: ""
    t.integer  "damage",                default: 0
    t.integer  "top_save",              default: 0
    t.integer  "top_threshold",         default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "proficiencies", force: true do |t|
    t.string   "name",         default: ""
    t.string   "description",  default: ""
    t.string   "requirements", default: ""
    t.integer  "bp_cost",      default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "proficiencies_races", force: true do |t|
    t.integer "proficiency_id"
    t.integer "race_id"
  end

  create_table "races", force: true do |t|
    t.string   "name",                        default: ""
    t.string   "description",                 default: ""
    t.integer  "str_mod",                     default: 0
    t.integer  "int_mod",                     default: 0
    t.integer  "wis_mod",                     default: 0
    t.integer  "dex_mod",                     default: 0
    t.integer  "con_mod",                     default: 0
    t.integer  "lks_mod",                     default: 0
    t.integer  "cha_mod",                     default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "hp_size_adjustment",          default: 0
    t.integer  "defense_adjustment_vs_large", default: 0
    t.integer  "defense_adjustment",          default: 0
    t.integer  "hide_in_natural",             default: 0
    t.float    "base_movement",               default: 0.0
    t.float    "reach_adjustment",            default: 0.0
    t.string   "size",                        default: ""
    t.string   "knock_back_size",             default: ""
    t.boolean  "low_light_vision",            default: false
    t.boolean  "init_die_bonus",              default: false
    t.integer  "male_height",                 default: 0
    t.integer  "female_height",               default: 0
    t.integer  "male_weight",                 default: 0
    t.integer  "female_weight",               default: 0
    t.integer  "lifespan",                    default: 0
  end

  create_table "races_skills", force: true do |t|
    t.integer "race_id"
    t.integer "skill_id"
    t.integer "count",    default: 1
  end

  create_table "races_talents", force: true do |t|
    t.integer "race_id"
    t.integer "talent_id"
  end

  create_table "skills", force: true do |t|
    t.string   "name",         default: ""
    t.string   "description",  default: ""
    t.integer  "bp_cost",      default: 0
    t.string   "main_attr",    default: ""
    t.string   "other_attr",   default: ""
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "third_attr",   default: ""
    t.boolean  "universal",    default: false
    t.string   "prerequisite", default: ""
    t.string   "materials",    default: ""
    t.string   "unskilled",    default: ""
    t.string   "novice",       default: ""
    t.string   "average",      default: ""
    t.string   "advanced",     default: ""
    t.string   "expert",       default: ""
    t.string   "master",       default: ""
  end

  create_table "specializations", force: true do |t|
    t.integer  "item_id"
    t.integer  "character_id"
    t.integer  "value",        default: 0
    t.string   "stat_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spells", force: true do |t|
    t.string   "name",                        default: ""
    t.string   "description",                 default: ""
    t.integer  "spellpoints",                 default: 0
    t.string   "spell_type",                  default: ""
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "verbal",                      default: false
    t.boolean  "somatic",                     default: false
    t.string   "material_component",          default: ""
    t.integer  "casting_time",                default: 0
    t.integer  "duration",                    default: 0
    t.string   "volume_of_effect_type",       default: ""
    t.integer  "volume_of_effect",            default: 0
    t.integer  "volume_increase",             default: 0
    t.integer  "volume_increase_cost",        default: 0
    t.integer  "range",                       default: 0
    t.integer  "range_increase",              default: 0
    t.integer  "range_increase_cost",         default: 0
    t.string   "target_damage",               default: ""
    t.string   "target_damage_increase",      default: ""
    t.integer  "target_damage_increase_cost", default: 0
    t.string   "area_damage",                 default: ""
    t.string   "area_damage_increase",        default: ""
    t.integer  "area_damage_increase_cost",   default: 0
    t.string   "special_increase1",           default: ""
    t.integer  "special_increase1_cost",      default: 0
    t.string   "special_increase2",           default: ""
    t.integer  "special_increase2_cost",      default: 0
    t.string   "saving_throw",                default: ""
    t.string   "saving_throw_result",         default: ""
    t.boolean  "bounce_damage",               default: false
    t.string   "damage_type",                 default: ""
    t.integer  "duration_increase",           default: 0
    t.integer  "duration_increase_cost",      default: 0
  end

  create_table "talents", force: true do |t|
    t.string   "name",          default: ""
    t.string   "description",   default: ""
    t.string   "requirements",  default: ""
    t.integer  "bp_cost",       default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "item_specific", default: false
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "admin_level"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
