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

ActiveRecord::Schema.define(version: 20140817010031) do

  create_table "records", force: true do |t|
    t.string  "domain", limit: 253, null: false
    t.integer "rtype",              null: false
    t.binary  "value",              null: false
  end

  add_index "records", ["domain"], name: "index_records_on_domain"
  add_index "records", ["value"], name: "index_records_on_value", unique: true

end
