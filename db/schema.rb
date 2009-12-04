# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20091204204133) do

  create_table "products", :force => true do |t|
    t.string   "name"
    t.integer  "energy"
    t.decimal  "portion",       :precision => 6, :scale => 2
    t.decimal  "protein",       :precision => 5, :scale => 2
    t.decimal  "carbohydrates", :precision => 5, :scale => 2
    t.decimal  "fat",           :precision => 5, :scale => 2
    t.decimal  "saturates",     :precision => 5, :scale => 2
    t.decimal  "fibre",         :precision => 5, :scale => 2
    t.decimal  "sodium",        :precision => 5, :scale => 2
    t.decimal  "added_sugars",  :precision => 5, :scale => 2
    t.string   "barcode"
    t.string   "kind"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
