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

ActiveRecord::Schema.define(version: 20140404023351) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bookmarkings", force: true do |t|
    t.integer "tag_id"
    t.integer "user_id"
  end

  create_table "channel_memberships", force: true do |t|
    t.integer "channel_id", null: false
    t.integer "user_id",    null: false
  end

  create_table "channels", force: true do |t|
    t.string   "name",                    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "users_count", default: 0
    t.string   "description"
    t.integer  "creator_id"
  end

  add_index "channels", ["name"], name: "index_channels_on_name", unique: true, using: :btree

  create_table "comments", force: true do |t|
    t.string   "title",            limit: 50, default: ""
    t.text     "comment"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "user_id"
    t.string   "role",                        default: "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id"], name: "index_comments_on_commentable_id", using: :btree
  add_index "comments", ["commentable_type"], name: "index_comments_on_commentable_type", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "conversations", force: true do |t|
    t.string   "subject",    default: ""
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "default_taggings", force: true do |t|
    t.integer "tag_id"
    t.integer "user_id"
  end

  create_table "follow_relationships", force: true do |t|
    t.integer  "follower_id", null: false
    t.integer  "followed_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "follow_relationships", ["followed_id"], name: "index_follow_relationships_on_followed_id", using: :btree
  add_index "follow_relationships", ["follower_id", "followed_id"], name: "index_follow_relationships_on_follower_id_and_followed_id", unique: true, using: :btree
  add_index "follow_relationships", ["follower_id"], name: "index_follow_relationships_on_follower_id", using: :btree

  create_table "impressions", force: true do |t|
    t.string   "impressionable_type"
    t.integer  "impressionable_id"
    t.integer  "user_id"
    t.string   "controller_name"
    t.string   "action_name"
    t.string   "view_name"
    t.string   "request_hash"
    t.string   "ip_address"
    t.string   "session_hash"
    t.text     "message"
    t.text     "referrer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "impressions", ["controller_name", "action_name", "ip_address"], name: "controlleraction_ip_index", using: :btree
  add_index "impressions", ["controller_name", "action_name", "request_hash"], name: "controlleraction_request_index", using: :btree
  add_index "impressions", ["controller_name", "action_name", "session_hash"], name: "controlleraction_session_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "ip_address"], name: "poly_ip_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "request_hash"], name: "poly_request_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "session_hash"], name: "poly_session_index", using: :btree
  add_index "impressions", ["impressionable_type", "message", "impressionable_id"], name: "impressionable_type_message_index", using: :btree
  add_index "impressions", ["user_id"], name: "index_impressions_on_user_id", using: :btree

  create_table "item_categories", force: true do |t|
    t.string  "name"
    t.integer "type_cd"
    t.integer "item_category_type_id"
  end

  create_table "item_category_types", force: true do |t|
    t.string "name"
  end

  create_table "items", force: true do |t|
    t.integer  "post_id",            null: false
    t.string   "name",               null: false
    t.string   "link"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "number",             null: false
    t.integer  "x",                  null: false
    t.integer  "y",                  null: false
    t.integer  "item_category_id"
    t.string   "url"
    t.string   "item_category_name"
  end

  add_index "items", ["post_id"], name: "index_items_on_post_id", using: :btree

  create_table "like_relationships", force: true do |t|
    t.integer  "user_id",    null: false
    t.integer  "post_id",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "like_relationships", ["post_id"], name: "index_like_relationships_on_post_id", using: :btree
  add_index "like_relationships", ["user_id", "post_id"], name: "index_like_relationships_on_user_id_and_post_id", unique: true, using: :btree
  add_index "like_relationships", ["user_id"], name: "index_like_relationships_on_user_id", using: :btree

  create_table "notifications", force: true do |t|
    t.string   "type"
    t.text     "body"
    t.string   "subject",              default: ""
    t.integer  "sender_id"
    t.string   "sender_type"
    t.integer  "conversation_id"
    t.boolean  "draft",                default: false
    t.datetime "updated_at",                           null: false
    t.datetime "created_at",                           null: false
    t.integer  "notified_object_id"
    t.string   "notified_object_type"
    t.string   "notification_code"
    t.string   "attachment"
    t.boolean  "global",               default: false
    t.datetime "expires"
  end

  add_index "notifications", ["conversation_id"], name: "index_notifications_on_conversation_id", using: :btree

  create_table "posts", force: true do |t|
    t.integer  "user_id",                              null: false
    t.string   "title",                                null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cloudinary_id",                        null: false
    t.text     "description"
    t.integer  "like_relationships_count", default: 0
    t.integer  "comments_count",           default: 0
    t.integer  "tags_count",               default: 0
    t.integer  "views_count",              default: 0, null: false
    t.string   "crop_str"
    t.string   "slug"
  end

  add_index "posts", ["slug"], name: "index_posts_on_slug", using: :btree
  add_index "posts", ["user_id"], name: "index_posts_on_user_id", using: :btree

  create_table "receipts", force: true do |t|
    t.integer  "receiver_id"
    t.string   "receiver_type"
    t.integer  "notification_id",                            null: false
    t.boolean  "is_read",                    default: false
    t.boolean  "trashed",                    default: false
    t.boolean  "deleted",                    default: false
    t.string   "mailbox_type",    limit: 25
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  add_index "receipts", ["notification_id"], name: "index_receipts_on_notification_id", using: :btree

  create_table "sign_in_authentications", force: true do |t|
    t.integer "user_id",  null: false
    t.string  "provider", null: false
    t.string  "uid",      null: false
  end

  add_index "sign_in_authentications", ["user_id"], name: "index_sign_in_authentications_on_user_id", using: :btree

  create_table "sites", force: true do |t|
    t.integer "user_id"
    t.string  "facebook"
    t.string  "twitter"
    t.string  "google"
    t.string  "weibo"
    t.string  "blog"
  end

  add_index "sites", ["user_id"], name: "index_sites_on_user_id", using: :btree

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "post_id"
    t.datetime "created_at"
  end

  add_index "taggings", ["post_id"], name: "index_taggings_on_post_id", using: :btree
  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id", using: :btree

  create_table "tags", force: true do |t|
    t.string  "name",                    null: false
    t.integer "posts_count", default: 0
    t.integer "category",    default: 0
  end

  create_table "users", force: true do |t|
    t.string   "email",                                                                                        null: false
    t.string   "encrypted_password",                                                                           null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,                                                           null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
    t.string   "description"
    t.string   "full_name",                                                                                    null: false
    t.string   "avatar_cloudinary_id",   default: "v1390343618/default_profile_4_reasonably_small_nt1wg6.png"
    t.integer  "posts_count",            default: 0
    t.integer  "followings_count",       default: 0
    t.integer  "followers_count",        default: 0
    t.integer  "channels_count",         default: 0
    t.integer  "channel_allowance",      default: 1,                                                           null: false
    t.boolean  "random_password",        default: false,                                                       null: false
    t.integer  "liked_posts_count",      default: 0
    t.integer  "likes_count",            default: 0
    t.string   "city"
    t.string   "college"
    t.boolean  "changed_username",       default: false,                                                       null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  add_foreign_key "notifications", "conversations", name: "notifications_on_conversation_id"

  add_foreign_key "receipts", "notifications", name: "receipts_on_notification_id"

end
