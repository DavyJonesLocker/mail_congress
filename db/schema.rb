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

ActiveRecord::Schema.define(:version => 20101206152059) do

  create_table "advocacy_groups", :force => true do |t|
    t.boolean  "approved",                          :default => false
    t.string   "name"
    t.string   "contact_name"
    t.string   "phone_number"
    t.string   "email",                             :default => "",    :null => false
    t.text     "purpose"
    t.string   "website"
    t.string   "encrypted_password", :limit => 128, :default => "",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "campaigns", :force => true do |t|
    t.integer  "advocacy_group_id"
    t.text     "body"
    t.text     "summary"
    t.string   "type",              :default => "both"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

# Could not dump table "federal_house_districts" because of following StandardError
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

  create_table "legislators", :force => true do |t|
    t.string  "level"
    t.string  "title"
    t.string  "firstname"
    t.string  "middlename"
    t.string  "lastname"
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
  end

  add_index "legislators", ["bioguide_id"], :name => "legislators_federal_bioguide_id"
  add_index "legislators", ["bioguide_id"], :name => "legislators_state_bioguide_id"
  add_index "legislators", ["district"], :name => "legislators_district"
  add_index "legislators", ["id"], :name => "legislators_id"

  create_table "letters", :force => true do |t|
    t.integer  "sender_id"
    t.integer  "campaign_id"
    t.text     "body"
    t.boolean  "printed",        :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "follow_up_made", :default => false
    t.string   "follow_up_id"
    t.string   "payment_type",   :default => "credit_card"
  end

  create_table "recipients", :force => true do |t|
    t.integer  "letter_id"
    t.integer  "legislator_id"
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

  create_table "states", :id => false, :force => true do |t|
    t.string  "code"
    t.string  "name"
    t.integer "fips"
  end

  add_index "states", ["code"], :name => "states_code", :unique => true
  add_index "states", ["fips"], :name => "states_fips", :unique => true

end
