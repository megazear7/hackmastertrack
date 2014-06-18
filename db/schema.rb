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

ActiveRecord::Schema.define(version: 20140618131612) do

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

  create_table "characters_talents", force: true do |t|
    t.integer "character_id"
    t.integer "talent_id"
  end

  create_table "encounters", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items", force: true do |t|
    t.string   "type"
    t.integer  "attack_mod"
    t.integer  "speed_mod"
    t.integer  "init_mod"
    t.integer  "defense_mod"
    t.integer  "damage_mod"
    t.integer  "damage_reduction"
    t.integer  "magic_level"
    t.integer  "weight"
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
  end

  create_table "proficiencies", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "requirements"
    t.integer  "bp_cost"
    t.integer  "item_id"
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

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
