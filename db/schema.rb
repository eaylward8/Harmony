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

ActiveRecord::Schema.define(version: 20160411145637) do

  create_table "doctors", force: :cascade do |t|
    t.string   "location"
    t.string   "specialty"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "first_name"
    t.string   "last_name"
  end

  create_table "drugs", force: :cascade do |t|
    t.string   "name"
    t.integer  "rxcui"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pharmacies", force: :cascade do |t|
    t.string   "name"
    t.string   "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "prescriptions", force: :cascade do |t|
    t.integer  "refills"
    t.integer  "fill_duration"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "doctor_id"
    t.integer  "pharmacy_id"
    t.integer  "user_id"
    t.integer  "drug_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "dose_size"
  end

  create_table "scheduled_doses", force: :cascade do |t|
    t.string   "time_of_day"
    t.integer  "prescription_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "password_digest"
  end

end
