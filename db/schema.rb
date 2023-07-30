# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_06_04_122930) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "active_storage_attachments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.uuid "record_id", null: false
    t.uuid "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "company_major_stores", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.string "company_code"
    t.integer "occupation"
    t.jsonb "vocab_achievement"
    t.jsonb "vocab_recommended"
    t.uuid "created_by"
    t.uuid "updated_by"
    t.uuid "deleted_by"
    t.datetime "created_at", default: -> { "now()" }, null: false
    t.datetime "updated_at", default: -> { "now()" }, null: false
    t.datetime "deleted_at"
    t.index ["user_id", "occupation"], name: "index_company_major_stores_on_user_id_occupation_idx"
  end

  create_table "company_middle_stores", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.string "company_code"
    t.integer "occupation"
    t.string "vocab_code"
    t.string "vocab_read"
    t.string "vocab_mean"
    t.uuid "created_by", null: false
    t.uuid "updated_by", null: false
    t.uuid "deleted_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["user_id"], name: "index_company_middle_stores_on_user_id"
  end

  create_table "company_store_contents", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "company_store_id", null: false
    t.string "company_code"
    t.string "occupation"
    t.string "vocab_code"
    t.string "vocab_read"
    t.string "vocab_mean"
    t.uuid "created_by", null: false
    t.uuid "updated_by", null: false
    t.uuid "deleted_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["company_store_id"], name: "index_company_store_contents_on_company_store_id"
  end

  create_table "company_stores", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "comp_id", null: false
    t.uuid "created_by", null: false
    t.uuid "updated_by", null: false
    t.uuid "deleted_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["comp_id"], name: "index_company_stores_on_comp_id"
  end

  create_table "comps", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "sei"
    t.string "mei"
    t.string "sei_kana"
    t.string "mei_kana"
    t.string "mobile"
    t.string "business_type"
    t.string "company_name"
    t.string "company_url"
    t.string "department"
    t.string "company_code"
    t.uuid "created_by", null: false
    t.uuid "updated_by", null: false
    t.uuid "deleted_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["reset_password_token"], name: "index_comps_on_reset_password_token", unique: true
  end

  create_table "job_profile_contents", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "job_profile_id", null: false
    t.integer "employment_sts"
    t.integer "occupation", default: 0, null: false
    t.string "ad_title"
    t.integer "salary", default: 0, null: false
    t.integer "location", default: [], null: false, array: true
    t.boolean "visa_support", default: false, null: false
    t.integer "visa_type", default: 0, null: false
    t.integer "year", default: 1970, null: false
    t.integer "month", default: [], null: false, array: true
    t.text "job_description"
    t.text "desire_qualification"
    t.uuid "created_by", null: false
    t.uuid "updated_by", null: false
    t.uuid "deleted_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["job_profile_id"], name: "index_job_profile_contents_on_job_profile_id"
  end

  create_table "job_profiles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "comp_id", null: false
    t.uuid "created_by", null: false
    t.uuid "updated_by", null: false
    t.uuid "deleted_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["comp_id"], name: "index_job_profiles_on_comp_id"
  end

  create_table "kanji_stores", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.serial "kanji_org", null: false
    t.string "kanji_code", null: false
    t.integer "kanji_no"
    t.jsonb "kanji_vocab"
    t.string "unit_sheet"
    t.jsonb "kanji_parts"
    t.text "parts_body"
    t.uuid "created_by", null: false
    t.uuid "updated_by", null: false
    t.uuid "deleted_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["kanji_org"], name: "index_kanji_stores_on_kanji_org", unique: true
  end

  create_table "matching_bases", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "company_id", null: false
    t.integer "occupation", null: false
    t.uuid "student_id", null: false
    t.jsonb "company_vocab"
    t.jsonb "student_vocab"
    t.text "job_description"
    t.uuid "created_by"
    t.uuid "updated_by"
    t.uuid "deleted_by"
    t.datetime "created_at", default: -> { "now()" }, null: false
    t.datetime "updated_at", default: -> { "now()" }, null: false
    t.datetime "deleted_at"
    t.index ["company_id", "occupation", "student_id"], name: "index_matching_bases_company_id_occupation_student_id_idx"
  end

  create_table "parts_stores", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.serial "parts_org", null: false
    t.string "parts_code", null: false
    t.integer "parts_stroke"
    t.jsonb "parts_kanji"
    t.text "kanji_body"
    t.uuid "created_by", null: false
    t.uuid "updated_by", null: false
    t.uuid "deleted_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["parts_org"], name: "index_parts_stores_on_parts_org", unique: true
  end

  create_table "profile_languages", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "profile_id", null: false
    t.integer "native_lang"
    t.integer "jp_level"
    t.integer "use_lang"
    t.integer "use_lang_level"
    t.uuid "created_by", null: false
    t.uuid "updated_by", null: false
    t.uuid "deleted_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["profile_id"], name: "index_profile_languages_on_profile_id"
  end

  create_table "profile_works", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "profile_id", null: false
    t.integer "work_country"
    t.string "work_place"
    t.string "work_type"
    t.date "start_date"
    t.date "end_date"
    t.uuid "created_by", null: false
    t.uuid "updated_by", null: false
    t.uuid "deleted_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["profile_id"], name: "index_profile_works_on_profile_id"
  end

  create_table "profiles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.string "call_name"
    t.integer "kokuseki"
    t.date "birthday"
    t.integer "sex"
    t.boolean "injapan_flg", default: false, null: false
    t.text "address"
    t.integer "visa_type"
    t.date "visa_end_date"
    t.date "desired_work_date"
    t.integer "jp_school_type"
    t.date "jp_school_date"
    t.integer "jp_school_end"
    t.string "jp_school_senko"
    t.string "jp_school_name"
    t.integer "school_type"
    t.date "school_date"
    t.integer "school_end"
    t.string "school_senko"
    t.string "school_name"
    t.text "skill"
    t.uuid "created_by", null: false
    t.uuid "updated_by", null: false
    t.uuid "deleted_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.string "address_country"
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "read_stores", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.serial "read_org", null: false
    t.string "read_code", null: false
    t.integer "vocab_org", null: false
    t.string "vocab_code", null: false
    t.jsonb "read_vocab"
    t.uuid "created_by", null: false
    t.uuid "updated_by", null: false
    t.uuid "deleted_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["read_org"], name: "index_read_stores_on_read_org", unique: true
  end

  create_table "store_contents", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "store_id", null: false
    t.string "user_code"
    t.string "jlpt_class"
    t.string "vocab_code"
    t.string "vocab_read"
    t.string "vocab_mean"
    t.integer "use"
    t.uuid "created_by", null: false
    t.uuid "updated_by", null: false
    t.uuid "deleted_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["store_id"], name: "index_store_contents_on_store_id"
  end

  create_table "stores", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.uuid "created_by", null: false
    t.uuid "updated_by", null: false
    t.uuid "deleted_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["user_id"], name: "index_stores_on_user_id"
  end

  create_table "student_major_stores", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.jsonb "major_vocab"
    t.jsonb "minor_vocab"
    t.jsonb "detail_vocab"
    t.text "job_description"
    t.uuid "created_by"
    t.uuid "updated_by"
    t.uuid "deleted_by"
    t.datetime "created_at", default: -> { "now()" }, null: false
    t.datetime "updated_at", default: -> { "now()" }, null: false
    t.datetime "deleted_at"
    t.index ["user_id"], name: "index_student_major_stores_user_id_idx"
  end

  create_table "student_middle_stores", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.string "user_code"
    t.string "jlpt_level"
    t.string "vocab_code"
    t.string "vocab_read"
    t.string "vocab_mean"
    t.uuid "created_by"
    t.uuid "updated_by"
    t.uuid "deleted_by"
    t.datetime "created_at", default: -> { "now()" }, null: false
    t.datetime "updated_at", default: -> { "now()" }, null: false
    t.datetime "deleted_at"
    t.string "place_to_use"
    t.index ["user_id"], name: "index_student_middle_stores_on_user_id"
  end

  create_table "student_profiles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.integer "employment_sts"
    t.integer "occupation", default: 0, null: false
    t.string "ad_title"
    t.integer "salary", default: 0, null: false
    t.integer "location"
    t.boolean "visa_support", default: false, null: false
    t.integer "visa_type", default: 0, null: false
    t.text "job_description"
    t.text "lang_id"
    t.uuid "created_by", null: false
    t.uuid "updated_by", null: false
    t.uuid "deleted_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["user_id"], name: "index_student_profiles_on_user_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.uuid "created_by"
    t.uuid "updated_by"
    t.uuid "deleted_by"
    t.string "sei"
    t.string "mei"
    t.string "sei_kana"
    t.string "mei_kana"
    t.string "mobile"
    t.string "lang_id", default: "EN", null: false
    t.boolean "mycard_sign", default: false, null: false
    t.string "business_type"
    t.boolean "company_flg", default: false, null: false
    t.string "company_name"
    t.string "company_type"
    t.string "company_url"
    t.string "department"
    t.string "company_code"
    t.string "jp_level"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "vocab_mycards", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.integer "vocab_mycard_org"
    t.integer "vocab_org", null: false
    t.string "vocab_code", null: false
    t.string "vocab_read"
    t.text "kanji_body"
    t.integer "jlpt_class"
    t.string "jlpt_level"
    t.text "parts_body"
    t.date "recent_date"
    t.integer "mycard_check"
    t.uuid "created_by"
    t.uuid "updated_by"
    t.uuid "deleted_by"
    t.datetime "created_at", default: -> { "now()" }, null: false
    t.datetime "updated_at", default: -> { "now()" }, null: false
    t.datetime "deleted_at"
    t.integer "mycard_level", default: 0, null: false
    t.index ["user_id", "vocab_code"], name: "index_vocab_mycards_user_id_vocab_code_idx"
  end

  create_table "vocab_stores", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.serial "vocab_org", null: false
    t.string "vocab_code", null: false
    t.integer "vocab_num"
    t.string "vocab_read"
    t.string "unit_sheet"
    t.string "kanji_sheet"
    t.jsonb "vocab_kanji"
    t.jsonb "nation_vocab", default: {}
    t.integer "jlpt_class", default: 0
    t.string "jlpt_level"
    t.integer "vocab_seq", default: 0
    t.boolean "excel_flag", default: false, null: false
    t.text "genre"
    t.boolean "active_sign", default: true, null: false
    t.uuid "created_by", null: false
    t.uuid "updated_by", null: false
    t.uuid "deleted_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["vocab_org"], name: "index_vocab_stores_on_vocab_org", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "company_major_stores", "users"
  add_foreign_key "company_middle_stores", "users"
  add_foreign_key "company_store_contents", "company_stores"
  add_foreign_key "company_stores", "comps"
  add_foreign_key "job_profile_contents", "job_profiles"
  add_foreign_key "job_profiles", "comps"
  add_foreign_key "matching_bases", "users", column: "company_id"
  add_foreign_key "matching_bases", "users", column: "student_id"
  add_foreign_key "profile_languages", "profiles"
  add_foreign_key "profile_works", "profiles"
  add_foreign_key "profiles", "users"
  add_foreign_key "store_contents", "stores"
  add_foreign_key "stores", "users"
  add_foreign_key "student_major_stores", "users"
  add_foreign_key "student_middle_stores", "users"
  add_foreign_key "student_profiles", "users"
  add_foreign_key "vocab_mycards", "users"
end
