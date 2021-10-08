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

ActiveRecord::Schema.define(version: 2021_10_08_072045) do

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "bookmarks", force: :cascade do |t|
    t.integer "user_id"
    t.integer "shrine_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shrine_id"], name: "index_bookmarks_on_shrine_id"
    t.index ["user_id"], name: "index_bookmarks_on_user_id"
  end

  create_table "gods", force: :cascade do |t|
    t.string "god_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "post_images", force: :cascade do |t|
    t.integer "post_id"
    t.string "image_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_post_images_on_post_id"
  end

  create_table "posts", force: :cascade do |t|
    t.integer "user_id"
    t.integer "shrine_id"
    t.text "body"
    t.date "visit_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shrine_id"], name: "index_posts_on_shrine_id"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "relationships", force: :cascade do |t|
    t.integer "follower_id"
    t.integer "followed_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["followed_id"], name: "index_relationships_on_followed_id"
    t.index ["follower_id"], name: "index_relationships_on_follower_id"
  end

  create_table "shrine_gods", force: :cascade do |t|
    t.integer "shrine_id"
    t.integer "god_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["god_id"], name: "index_shrine_gods_on_god_id"
    t.index ["shrine_id", "god_id"], name: "index_shrine_gods_on_shrine_id_and_god_id", unique: true
    t.index ["shrine_id"], name: "index_shrine_gods_on_shrine_id"
  end

  create_table "shrine_images", force: :cascade do |t|
    t.integer "shrine_id"
    t.string "image_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shrine_id"], name: "index_shrine_images_on_shrine_id"
  end

  create_table "shrine_tags", force: :cascade do |t|
    t.integer "shrine_id"
    t.integer "tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shrine_id", "tag_id"], name: "index_shrine_tags_on_shrine_id_and_tag_id", unique: true
    t.index ["shrine_id"], name: "index_shrine_tags_on_shrine_id"
    t.index ["tag_id"], name: "index_shrine_tags_on_tag_id"
  end

  create_table "shrines", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.text "introduction"
    t.integer "impressions_count", default: 0
    t.float "latitude"
    t.float "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string "tag_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name"
    t.string "introduction"
    t.string "profile_image_id"
    t.boolean "is_deleted", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
