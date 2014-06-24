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

ActiveRecord::Schema.define(version: 20140624012111) do

  create_table "kalibro_modules", force: true do |t|
    t.string   "name"
    t.string   "granularity"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "module_result_id"
  end

  create_table "metric_results", force: true do |t|
    t.integer  "module_result_id"
    t.integer  "metric_configuration_id"
    t.float    "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "module_results", force: true do |t|
    t.float    "grade"
    t.integer  "parent_id"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "process_times", force: true do |t|
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "processing_id"
  end

  create_table "processings", force: true do |t|
    t.string   "state"
    t.integer  "process_time_id"
    t.integer  "repository_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "repositories", force: true do |t|
    t.string   "name"
    t.string   "scm_type"
    t.string   "address"
    t.string   "description",      default: ""
    t.string   "license",          default: ""
    t.integer  "period",           default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "configuration_id"
    t.integer  "project_id"
  end

end
