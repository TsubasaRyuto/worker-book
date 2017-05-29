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

ActiveRecord::Schema.define(version: 20170523122157) do

  create_table "agreements", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "worker_id",                     null: false
    t.integer  "job_content_id",                null: false
    t.boolean  "active",         default: true, null: false
    t.datetime "activated_at"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["job_content_id"], name: "index_agreements_on_job_content_id", using: :btree
    t.index ["worker_id"], name: "index_agreements_on_worker_id", using: :btree
  end

  create_table "chat_files", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "chat_id",    null: false
    t.string   "filename",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chat_id"], name: "index_chat_files_on_chat_id", using: :btree
  end

  create_table "chat_images", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "chat_id",    null: false
    t.string   "image",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chat_id"], name: "index_chat_images_on_chat_id", using: :btree
  end

  create_table "chats", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "agreement_id",                                    null: false
    t.string   "sender_username",                                 null: false
    t.string   "receiver_username",                               null: false
    t.text     "message",           limit: 65535,                 null: false
    t.boolean  "read_flg",                        default: false, null: false
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.index ["agreement_id"], name: "index_chats_on_agreement_id", using: :btree
  end

  create_table "client_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "client_id",                         null: false
    t.string   "last_name",                         null: false
    t.string   "first_name",                        null: false
    t.string   "username",                          null: false
    t.string   "email",                             null: false
    t.integer  "user_type",         default: 0
    t.string   "password_digest",                   null: false
    t.string   "remember_digest"
    t.string   "activation_digest"
    t.boolean  "activated",         default: false, null: false
    t.datetime "activated_at"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.index ["client_id"], name: "index_client_users_on_client_id", using: :btree
  end

  create_table "clients", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name",                          null: false
    t.string   "corporate_site",                null: false
    t.string   "clientname",                    null: false
    t.string   "location",       default: "01", null: false
    t.string   "logo",                          null: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "job_contents", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "client_id",                                 null: false
    t.string   "title",                                     null: false
    t.text     "content",     limit: 65535,                 null: false
    t.text     "note",        limit: 65535,                 null: false
    t.datetime "start_date",                                null: false
    t.datetime "finish_date",                               null: false
    t.boolean  "finished",                  default: false, null: false
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.index ["client_id"], name: "index_job_contents_on_client_id", using: :btree
  end

  create_table "job_requests", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "worker_id",         null: false
    t.integer  "job_content_id",    null: false
    t.string   "activation_digest"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["job_content_id"], name: "index_job_requests_on_job_content_id", using: :btree
    t.index ["worker_id"], name: "index_job_requests_on_worker_id", using: :btree
  end

  create_table "taggings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "tag_id"
    t.string   "taggable_type"
    t.integer  "taggable_id"
    t.string   "tagger_type"
    t.integer  "tagger_id"
    t.string   "context",       limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context", using: :btree
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
    t.index ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy", using: :btree
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id", using: :btree
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type", using: :btree
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type", using: :btree
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id", using: :btree
  end

  create_table "tags", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "name",                       collation: "utf8_bin"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true, using: :btree
  end

  create_table "worker_accounts", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "id"
    t.boolean  "bank",         default: true,  null: false
    t.boolean  "post_bank",    default: false, null: false
    t.string   "bank_name"
    t.string   "branch_name"
    t.boolean  "type",         default: false, null: false
    t.string   "account_name"
    t.string   "number"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.index ["id"], name: "index_worker_accounts_on_id", unique: true, using: :btree
  end

  create_table "worker_addresses", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "id",                       null: false
    t.string   "postcode",     limit: 7,   null: false
    t.string   "prefecture",   limit: 2
    t.string   "city",         limit: 200
    t.string   "house_number", limit: 200
    t.string   "phone_number", limit: 13
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["id"], name: "index_worker_addresses_on_id", unique: true, using: :btree
  end

  create_table "worker_profiles", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "id",                                                    null: false
    t.boolean  "type_web_developer",                    default: false, null: false
    t.boolean  "type_mobile_developer",                 default: false, null: false
    t.boolean  "type_game_developer",                   default: false, null: false
    t.boolean  "type_desktop_developer",                default: false, null: false
    t.boolean  "type_ai_developer",                     default: false, null: false
    t.boolean  "type_qa_testing",                       default: false, null: false
    t.boolean  "type_web_mobile_desiner",               default: false, null: false
    t.boolean  "type_project_maneger",                  default: false, null: false
    t.boolean  "type_other",                            default: false, null: false
    t.integer  "availability",                          default: 0,     null: false
    t.string   "past_performance1",                                     null: false
    t.string   "past_performance2"
    t.string   "past_performance3"
    t.string   "past_performance4"
    t.integer  "unit_price",                            default: 30000, null: false
    t.text     "appeal_note",             limit: 65535,                 null: false
    t.string   "picture",                                               null: false
    t.string   "location",                              default: "01",  null: false
    t.string   "employment_history1",                                   null: false
    t.string   "employment_history2"
    t.string   "employment_history3"
    t.string   "employment_history4"
    t.boolean  "currently_freelancer",                  default: true,  null: false
    t.boolean  "active",                                default: true,  null: false
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.index ["id"], name: "index_worker_profiles_on_id", unique: true, using: :btree
  end

  create_table "workers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "last_name",                         null: false
    t.string   "first_name",                        null: false
    t.string   "username",                          null: false
    t.string   "email",                             null: false
    t.string   "password_digest",                   null: false
    t.string   "remember_digest"
    t.string   "activation_digest"
    t.boolean  "activated",         default: false, null: false
    t.datetime "activated_at"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

end
