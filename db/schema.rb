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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101122162405) do

  create_table "campaigns", :force => true do |t|
    t.integer  "partner_id"
    t.text     "body"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

# Could not dump table "cd99_110" because of following StandardError
#   Unknown type 'geometry' for column 'the_geom'

  create_table "geometry_columns", :id => false, :force => true do |t|
    t.string  "f_table_catalog",   :limit => 256, :null => false
    t.string  "f_table_schema",    :limit => 256, :null => false
    t.string  "f_table_name",      :limit => 256, :null => false
    t.string  "f_geometry_column", :limit => 256, :null => false
    t.integer "coord_dimension",                  :null => false
    t.integer "srid",                             :null => false
    t.string  "type",              :limit => 30,  :null => false
  end

  create_table "legislators", :id => false, :force => true do |t|
    t.string  "title"
    t.string  "firstname"
    t.string  "middlename"
    t.string  "name_suffix"
    t.string  "nickname"
    t.string  "party"
    t.string  "state"
    t.string  "district"
    t.boolean "in_office"
    t.string  "gender",            :limit => 1
    t.string  "phone"
    t.string  "fax"
    t.string  "website"
    t.string  "webform"
    t.string  "email"
    t.string  "congress_office"
    t.string  "bioguide_id"
    t.string  "votesmart_id"
    t.string  "fec_id"
    t.string  "govtrack_id"
    t.string  "crp_id"
    t.string  "eventful_id"
    t.string  "twitter_id"
    t.string  "congresspedia_url"
    t.string  "youtube_url"
    t.string  "official_rss"
    t.string  "senate_class"
    t.date    "birthdate"
    t.string  "lastname"
  end

  add_index "legislators", ["district"], :name => "legislators_district"

  create_table "letters", :force => true do |t|
    t.integer  "sender_id"
    t.integer  "campaign_id"
    t.text     "body"
    t.boolean  "printed",     :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "recipients", :force => true do |t|
    t.integer  "letter_id"
    t.string   "legislator_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "senders", :force => true do |t|
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "street"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spatial_ref_sys", :id => false, :force => true do |t|
    t.integer "srid",                      :null => false
    t.string  "auth_name", :limit => 256
    t.integer "auth_srid"
    t.string  "srtext",    :limit => 2048
    t.string  "proj4text", :limit => 2048
  end

  create_table "states", :id => false, :force => true do |t|
    t.string  "code"
    t.string  "name"
    t.integer "fips"
  end

  add_index "states", ["code"], :name => "states_code", :unique => true
  add_index "states", ["fips"], :name => "states_fips", :unique => true

end
