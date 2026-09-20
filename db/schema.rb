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

ActiveRecord::Schema[7.0].define(version: 2026_09_19_000000) do
  # These are extensions that must be enabled in order to support this database
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

  create_table "audio_as", id: :uuid, default: -> { "gen_random_uuid()" }, comment: "会話のタイトルを格納するテーブル", force: :cascade do |t|
    t.string "title_nation", comment: "タイトルの国別情報"
    t.integer "sort", comment: "ソート"
    t.datetime "created_at", default: -> { "now()" }, null: false, comment: "作成日時と更新日時"
    t.datetime "updated_at", default: -> { "now()" }, null: false, comment: "作成日時と更新日時"
    t.datetime "deleted_at", comment: "削除日時"
    t.uuid "created_by", null: false, comment: "作成者"
    t.uuid "updated_by", null: false, comment: "更新者"
    t.uuid "deleted_by", comment: "削除者"
  end

  create_table "audio_bs", id: :uuid, default: -> { "gen_random_uuid()" }, comment: "音声の経路情報を格納するテーブル", force: :cascade do |t|
    t.uuid "audio_a_id", null: false
    t.integer "sort", comment: "ソート"
    t.string "title_nation", comment: "タイトルの国別情報"
    t.datetime "created_at", default: -> { "now()" }, null: false, comment: "作成日時と更新日時"
    t.datetime "updated_at", default: -> { "now()" }, null: false, comment: "作成日時と更新日時"
    t.datetime "deleted_at", comment: "削除日時"
    t.uuid "created_by", null: false, comment: "作成者"
    t.uuid "updated_by", null: false, comment: "更新者"
    t.uuid "deleted_by", comment: "削除者"
    t.index ["audio_a_id", "id"], name: "index_audio_bs_on_audio_a_id_and_audio_bs_id"
    t.index ["audio_a_id"], name: "index_audio_bs_on_audio_a_id"
  end

  create_table "audio_c_contents", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "audio_c_id", null: false
    t.text "content"
    t.integer "sort", default: 0, null: false
    t.uuid "created_by", null: false
    t.uuid "updated_by", null: false
    t.uuid "deleted_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["audio_c_id"], name: "index_audio_c_contents_on_audio_c_id"
  end

  create_table "audio_cs", id: :uuid, default: -> { "gen_random_uuid()" }, comment: "音声を格納するテーブル", force: :cascade do |t|
    t.uuid "audio_b_id", null: false, comment: "関連するaudio_bテーブルのレコードのID"
    t.string "title_nation", comment: "国別情報（JSON形式）"
    t.jsonb "case_name_nation", comment: "ケース名の国別情報"
    t.integer "title_sort", comment: "ケース名のソート順"
    t.integer "case_name_sort", comment: "ケース名のソート順"
    t.datetime "created_at", default: -> { "now()" }, null: false, comment: "作成日時と更新日時"
    t.datetime "updated_at", default: -> { "now()" }, null: false, comment: "作成日時と更新日時"
    t.datetime "deleted_at", comment: "削除日時"
    t.uuid "created_by", null: false, comment: "作成者"
    t.uuid "updated_by", null: false, comment: "更新者"
    t.uuid "deleted_by", comment: "削除者"
    t.index ["audio_b_id", "id"], name: "index_audio_cs_on_audio_b_id_and_audio_cs_id"
    t.index ["audio_b_id"], name: "index_audio_cs_on_audio_b_id"
  end

  create_table "audio_ds", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "audio_c_content_id", null: false
    t.integer "sort", default: 0, null: false
    t.boolean "customer_flg", default: false, null: false
    t.boolean "voice_gender_flg", default: false, null: false
    t.text "content"
    t.uuid "created_by", null: false
    t.uuid "updated_by", null: false
    t.uuid "deleted_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["audio_c_content_id"], name: "index_audio_ds_on_audio_c_content_id"
  end

  create_table "azures", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "access_key", null: false
    t.string "subdomain", null: false
    t.boolean "enable_check_auth", default: true, null: false
    t.uuid "created_by", null: false
    t.uuid "updated_by", null: false
    t.uuid "deleted_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  create_table "block_ips", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "ipaddr"
    t.uuid "created_by", null: false
    t.uuid "updated_by", null: false
    t.uuid "deleted_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  create_table "channels", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "channel_name"
    t.uuid "created_by", null: false
    t.uuid "updated_by", null: false
    t.uuid "deleted_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
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
    t.uuid "comp_id"
    t.integer "user_count", default: 9999, null: false
    t.integer "access_type", default: 0, null: false
    t.boolean "login_flg", default: false, null: false
    t.uuid "channel_id"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.index ["channel_id"], name: "index_comps_on_channel_id"
    t.index ["comp_id"], name: "index_comps_on_comp_id"
    t.index ["reset_password_token"], name: "index_comps_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_comps_on_unlock_token", unique: true
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

  create_table "kanji_tables", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "kanji_code"
    t.integer "sort", default: 0, null: false
    t.string "kanji_sheet"
    t.text "parts_body"
    t.text "vocab_body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.uuid "created_by", null: false
    t.uuid "updated_by", null: false
    t.uuid "deleted_by"
  end

  create_table "kanji_vocabs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "sort", default: 0, null: false
    t.uuid "kanji_table_id", null: false
    t.uuid "vocab_table_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.uuid "created_by", null: false
    t.uuid "updated_by", null: false
    t.uuid "deleted_by"
    t.index ["kanji_table_id"], name: "index_kanji_vocabs_on_kanji_table_id"
    t.index ["vocab_table_id"], name: "index_kanji_vocabs_on_vocab_table_id"
  end

  create_table "languages", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "langs_type", null: false
    t.uuid "langs_id", null: false
    t.text "content"
    t.string "language", null: false
    t.integer "sort", default: 0, null: false
    t.uuid "created_by", null: false
    t.uuid "updated_by", null: false
    t.uuid "deleted_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.boolean "male_flg", default: false, null: false
    t.index ["langs_type", "langs_id"], name: "index_langs_on_langs"
  end

  create_table "parts_kanjis", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "sort", default: 0
    t.uuid "parts_table_id", null: false
    t.uuid "kanji_table_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.uuid "created_by", null: false
    t.uuid "updated_by", null: false
    t.uuid "deleted_by"
    t.index ["kanji_table_id"], name: "index_parts_kanjis_on_kanji_table_id"
    t.index ["parts_table_id"], name: "index_parts_kanjis_on_parts_table_id"
  end

  create_table "parts_tables", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "parts_code"
    t.integer "parts_stroke"
    t.integer "sort", default: 0, null: false
    t.text "kanji_body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.uuid "created_by", null: false
    t.uuid "updated_by", null: false
    t.uuid "deleted_by"
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

  create_table "profile_qualifications", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "profile_id", null: false
    t.integer "achieved_year"
    t.integer "achieved_month"
    t.string "qualification_name"
    t.uuid "created_by", null: false
    t.uuid "updated_by", null: false
    t.uuid "deleted_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["profile_id"], name: "index_profile_qualifications_on_profile_id"
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
    t.string "name_kana"
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
    t.integer "desired_job_type"
    t.integer "desired_industry"
    t.integer "desired_work_place"
    t.integer "japanese_level"
    t.integer "english_level"
    t.integer "toeic_score"
    t.string "native_language"
    t.index ["user_id"], name: "index_profiles_on_user_id"
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

  create_table "syslogs", force: :cascade do |t|
    t.datetime "occurred_at", precision: nil
    t.text "context"
    t.string "log_type"
    t.uuid "created_by", null: false
    t.uuid "updated_by", null: false
    t.uuid "deleted_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at", precision: nil
  end

  create_table "tokutei_answers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "tokutei_question_id", null: false
    t.string "title", null: false
    t.integer "sort", default: 0, null: false
    t.boolean "image_flg", default: false, null: false
    t.boolean "audio_flg", default: false, null: false
    t.text "content", null: false
    t.boolean "correct_flg", default: false, null: false
    t.uuid "created_by", null: false
    t.uuid "updated_by", null: false
    t.uuid "deleted_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["tokutei_question_id"], name: "index_tokutei_answers_on_tokutei_question_id"
  end

  create_table "tokutei_explains", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "explains_type", null: false
    t.uuid "explains_id", null: false
    t.text "content"
    t.boolean "image_flg", default: false, null: false
    t.boolean "audio_flg", default: false, null: false
    t.uuid "created_by", null: false
    t.uuid "updated_by", null: false
    t.uuid "deleted_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.text "content_hex"
    t.index ["explains_type", "explains_id"], name: "index_tokutei_explains_on_explains"
  end

  create_table "tokutei_questions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "tokutei_id", null: false
    t.string "title", null: false
    t.integer "sort", default: 0, null: false
    t.boolean "image_flg", default: false, null: false
    t.boolean "audio_flg", default: false, null: false
    t.text "content", null: false
    t.uuid "created_by", null: false
    t.uuid "updated_by", null: false
    t.uuid "deleted_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.text "content_hex"
    t.index ["tokutei_id"], name: "index_tokutei_questions_on_tokutei_id"
  end

  create_table "tokuteis", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "tokutei_id"
    t.string "title", null: false
    t.integer "sort", default: 0, null: false
    t.integer "code", default: 0, null: false
    t.uuid "created_by", null: false
    t.uuid "updated_by", null: false
    t.uuid "deleted_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["tokutei_id"], name: "index_tokuteis_on_tokutei_id"
  end

  create_table "user_channels", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.uuid "channel_id", null: false
    t.uuid "created_by", null: false
    t.uuid "updated_by", null: false
    t.uuid "deleted_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["channel_id"], name: "index_user_channels_on_channel_id"
    t.index ["user_id"], name: "index_user_channels_on_user_id"
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
    t.string "sei", null: false
    t.string "mei", null: false
    t.string "sei_kana", null: false
    t.string "mei_kana", null: false
    t.string "mobile", null: false
    t.string "lang_id", default: "EN", null: false
    t.boolean "mycard_sign", default: false, null: false
    t.string "jp_level"
    t.integer "entry_no", default: 0, null: false
    t.uuid "comp_id"
    t.integer "access_type", default: 0, null: false
    t.boolean "login_flg", default: true, null: false
    t.string "stripe_customer_id"
    t.string "subscription_status", default: "incomplete", null: false
    t.string "plan"
    t.json "billing_address"
    t.string "stripe_subscription_id"
    t.string "token"
    t.boolean "email_verify_flg", default: false, null: false
    t.date "trial_end_date"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "email_verification_sent_at"
    t.index ["comp_id"], name: "index_users_on_comp_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["stripe_customer_id"], name: "index_users_on_stripe_customer_id", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "vocab_genre_contents", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "vocab_genre_id", null: false
    t.uuid "vocab_table_id", null: false
    t.boolean "hide_flg", default: false, null: false
    t.integer "sort", default: 0, null: false
    t.uuid "created_by", null: false
    t.uuid "updated_by", null: false
    t.uuid "deleted_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["vocab_genre_id"], name: "index_vocab_genre_contents_on_vocab_genre_id"
    t.index ["vocab_table_id"], name: "index_vocab_genre_contents_on_vocab_table_id"
  end

  create_table "vocab_genres", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "vocab_genre_id"
    t.string "title", null: false
    t.integer "sort", default: 0, null: false
    t.boolean "hide_flg", default: false, null: false
    t.uuid "created_by", null: false
    t.uuid "updated_by", null: false
    t.uuid "deleted_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.uuid "channel_id"
    t.index ["channel_id"], name: "index_vocab_genres_on_channel_id"
    t.index ["vocab_genre_id"], name: "index_vocab_genres_on_vocab_genre_id"
  end

  create_table "vocab_mycards", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.integer "mycard_check"
    t.uuid "created_by", null: false
    t.uuid "updated_by", null: false
    t.uuid "deleted_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.integer "mycard_level", default: 0, null: false
    t.uuid "vocab_table_id", null: false
    t.index ["user_id"], name: "index_vocab_mycards_on_user_id"
    t.index ["vocab_table_id"], name: "index_vocab_mycards_on_vocab_table_id"
  end

  create_table "vocab_nations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "vocab_table_id", null: false
    t.integer "sort", default: 0, null: false
    t.string "lang"
    t.text "nation_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.uuid "created_by", null: false
    t.uuid "updated_by", null: false
    t.uuid "deleted_by"
    t.boolean "hide_flg", default: false, null: false
    t.text "example"
    t.index ["vocab_table_id", "lang"], name: "vocab_nations_vocab_table_id_lang", unique: true
  end

  create_table "vocab_tables", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "vocab_code"
    t.integer "sort", default: 0, null: false
    t.integer "kanji_numb"
    t.text "kanji_body"
    t.string "vocab_read"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.uuid "created_by", null: false
    t.uuid "updated_by", null: false
    t.uuid "deleted_by"
    t.integer "jlpt_level", default: 0
    t.boolean "hide_flg", default: false, null: false
    t.text "example"
    t.uuid "channel_id"
    t.index ["channel_id"], name: "index_vocab_tables_on_channel_id"
    t.index ["vocab_code"], name: "vocab_tables_vocab_code"
  end

  create_table "webhook_events", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "source"
    t.json "data"
    t.integer "state", default: 0, null: false
    t.string "external_id"
    t.string "processing_errors"
    t.uuid "created_by", null: false
    t.uuid "updated_by", null: false
    t.uuid "deleted_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "audio_bs", "audio_as"
  add_foreign_key "audio_c_contents", "audio_cs"
  add_foreign_key "audio_cs", "audio_bs"
  add_foreign_key "audio_ds", "audio_c_contents"
  add_foreign_key "company_store_contents", "company_stores"
  add_foreign_key "company_stores", "comps"
  add_foreign_key "comps", "channels"
  add_foreign_key "comps", "comps"
  add_foreign_key "job_profile_contents", "job_profiles"
  add_foreign_key "job_profiles", "comps"
  add_foreign_key "kanji_vocabs", "vocab_tables", name: "kanji_vocabs_vocab_table_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "parts_kanjis", "parts_tables", name: "parts_kanjis_parts_table_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "profile_languages", "profiles"
  add_foreign_key "profile_qualifications", "profiles"
  add_foreign_key "profile_works", "profiles"
  add_foreign_key "profiles", "users"
  add_foreign_key "store_contents", "stores", name: "store_contents_store_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "stores", "users", name: "stores_user_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "tokutei_answers", "tokutei_questions"
  add_foreign_key "tokutei_questions", "tokuteis"
  add_foreign_key "tokuteis", "tokuteis"
  add_foreign_key "user_channels", "channels"
  add_foreign_key "user_channels", "users"
  add_foreign_key "users", "comps"
  add_foreign_key "vocab_genre_contents", "vocab_genres", name: "vocab_genre_contents_vocab_genre_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "vocab_genre_contents", "vocab_tables", name: "vocab_genre_contents_vocab_table_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "vocab_genres", "channels"
  add_foreign_key "vocab_genres", "vocab_genres", name: "vocab_genres_vocab_genre_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "vocab_mycards", "users", name: "vocab_mycards_user_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "vocab_mycards", "vocab_tables", name: "vocab_mycards_vocab_table_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "vocab_nations", "vocab_tables", name: "vocab_nations_vocab_table_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "vocab_tables", "channels"
end
