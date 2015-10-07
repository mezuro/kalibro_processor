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

ActiveRecord::Schema.define(version: 20151002172231) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",               default: 0, null: false
    t.integer  "attempts",               default: 0, null: false
    t.text     "handler",                            null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "kalibro_modules", force: :cascade do |t|
    t.string   "long_name",        limit: 255
    t.string   "granularity",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "module_result_id"
  end

  create_table "metric_results", force: :cascade do |t|
    t.integer  "module_result_id"
    t.integer  "metric_configuration_id"
    t.float    "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type",                              default: "MetricResult", null: false
    t.integer  "line_number"
    t.text     "message"
    t.integer  "related_hotspot_metric_results_id"
  end

  add_index "metric_results", ["related_hotspot_metric_results_id"], name: "index_metric_results_on_related_hotspot_metric_results_id", using: :btree

  create_table "module_results", force: :cascade do |t|
    t.float    "grade"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "processing_id"
  end

  add_index "module_results", ["parent_id"], name: "index_module_results_on_parent_id", using: :btree

  create_table "process_times", force: :cascade do |t|
    t.string   "state",         limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "processing_id"
    t.float    "time"
  end

  create_table "processings", force: :cascade do |t|
    t.string   "state",                 limit: 255
    t.integer  "repository_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "root_module_result_id"
    t.text     "error_message"
  end

  create_table "projects", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "description", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "related_hotspot_metric_results", force: :cascade do |t|
  end

  create_table "repositories", force: :cascade do |t|
    t.string   "name",                     limit: 255
    t.string   "scm_type",                 limit: 255
    t.string   "address",                  limit: 255
    t.string   "description",              limit: 255, default: ""
    t.string   "license",                  limit: 255, default: ""
    t.integer  "period",                               default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "kalibro_configuration_id"
    t.integer  "project_id"
    t.string   "code_directory",           limit: 255
    t.string   "branch",                               default: "master", null: false
  end

  add_foreign_key "metric_results", "related_hotspot_metric_results", column: "related_hotspot_metric_results_id"
end
