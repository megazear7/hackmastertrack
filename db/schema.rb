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

ActiveRecord::Schema.define(version: 20140709154239) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ability_scores", force: true do |t|
    t.string   "ability"
    t.text     "value_range"
    t.integer  "feat_of_strength"
    t.integer  "lift"
    t.integer  "carry"
    t.integer  "drag"
    t.integer  "damage_mod"
    t.integer  "init_mod"
    t.integer  "speed_mod"
    t.integer  "attack_mod"
    t.integer  "defense_mod"
    t.integer  "turning_mod"
    t.integer  "feat_of_agility"
    t.integer  "mental_saving_throw_bonus"
    t.integer  "dodge_saving_throw_bonus"
    t.integer  "physical_saving_throw_bonus"
    t.integer  "morale_mod"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "min"
    t.float    "max"
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
  end

  create_table "characters", force: true do |t|
    t.float    "strength"
    t.float    "intelligence"
    t.float    "wisdom"
    t.float    "dexterity"
    t.float    "constitution"
    t.float    "looks"
    t.float    "charisma"
    t.float    "honor"
    t.float    "fame"
    t.integer  "building_points"
    t.integer  "health"
    t.string   "name"
    t.integer  "level"
    t.string   "alignment"
    t.string   "sex"
    t.integer  "age"
    t.integer  "height"
    t.integer  "weight"
    t.string   "hair"
    t.string   "eyes"
    t.string   "handedness"
    t.string   "trade_coins"
    t.integer  "copper"
    t.integer  "silver"
    t.integer  "gold"
    t.integer  "spell_points"
    t.integer  "luck_points"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "exp"
    t.integer  "mentor_id"
    t.integer  "left_hand_item_id"
    t.integer  "right_hand_item_id"
    t.integer  "body_item_id"
    t.integer  "character_class_id"
    t.integer  "race_id"
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
  end

  create_table "characters_spells", force: true do |t|
    t.integer "character_id"
    t.integer "spell_id"
  end

  create_table "characters_talents", force: true do |t|
    t.integer "character_id"
    t.integer "talent_id"
  end

  create_table "encounters", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "campaign_id"
  end

  create_table "items", force: true do |t|
    t.integer  "attack_mod"
    t.integer  "speed_mod"
    t.integer  "init_mod"
    t.integer  "defense_mod"
    t.integer  "damage_mod"
    t.integer  "damage_reduction"
    t.integer  "magic_level"
    t.float    "weight"
    t.integer  "cover_value"
    t.string   "location"
    t.string   "damage"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "shield_size"
    t.string   "armor_type"
    t.string   "name"
    t.string   "description"
    t.integer  "attack_speed"
    t.integer  "jab_speed"
    t.float    "reach"
    t.float    "buy_cost"
    t.float    "sell_value"
    t.string   "damage_type"
    t.integer  "heal_value"
    t.string   "item_type"
    t.integer  "high_avail"
    t.integer  "med_avail"
    t.integer  "low_avail"
    t.integer  "init_die_mod"
    t.integer  "movement_rate_reduction"
    t.integer  "crouching_cover_value"
    t.string   "shield_damage"
    t.integer  "str_required"
    t.string   "skill_level"
    t.boolean  "dismount"
    t.integer  "hvy_armor"
    t.boolean  "set_for_charge"
    t.string   "pole_arm_defense"
    t.string   "pole_arm_type"
    t.integer  "phalanx"
    t.string   "size"
    t.integer  "max_range"
    t.integer  "range_short"
    t.integer  "range_medium"
    t.integer  "range_long"
    t.integer  "range_maximum"
    t.integer  "proficiency_id"
    t.boolean  "two_handed"
    t.boolean  "mounted"
    t.boolean  "sword"
  end

  create_table "levels", force: true do |t|
    t.integer  "level_value"
    t.integer  "init_mod"
    t.integer  "attack_mod"
    t.integer  "speed_mod"
    t.integer  "spell_points"
    t.integer  "character_class_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "monsters", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.text     "combat_and_tactics"
    t.text     "habitat_and_society"
    t.text     "ecology"
    t.text     "attack_description"
    t.integer  "health"
    t.boolean  "template"
    t.string   "size"
    t.string   "weight"
    t.string   "intelligence"
    t.integer  "fatigue_factor"
    t.integer  "crawl"
    t.integer  "walk"
    t.integer  "jog"
    t.integer  "run"
    t.integer  "sprint"
    t.integer  "physical_save"
    t.integer  "mental_save"
    t.integer  "dodge_save"
    t.string   "activity_cycle"
    t.string   "no_appearing"
    t.integer  "chance_in_lair"
    t.string   "frequency"
    t.string   "alignment"
    t.string   "vision_type"
    t.string   "awareness_and_senses"
    t.string   "habitat"
    t.string   "diet"
    t.string   "organization"
    t.string   "climate"
    t.string   "medicinal_yield"
    t.string   "spell_component_yield"
    t.string   "hide_or_trophy"
    t.string   "treasure"
    t.string   "edible"
    t.string   "other_yield"
    t.integer  "exp_value"
    t.integer  "will_factor"
    t.integer  "speed"
    t.integer  "attack"
    t.integer  "init"
    t.integer  "defense"
    t.integer  "damage_reduction"
    t.string   "reach"
    t.integer  "damage"
    t.integer  "top_save"
    t.integer  "top_threshold"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "proficiencies", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "requirements"
    t.integer  "bp_cost"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "races", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "str_mod"
    t.integer  "int_mod"
    t.integer  "wis_mod"
    t.integer  "dex_mod"
    t.integer  "con_mod"
    t.integer  "lks_mod"
    t.integer  "cha_mod"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "skills", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "bp_cost"
    t.string   "main_attr"
    t.string   "other_attr"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spells", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "spellpoints"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "talents", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "requirements"
    t.integer  "bp_cost"
    t.integer  "item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
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
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
