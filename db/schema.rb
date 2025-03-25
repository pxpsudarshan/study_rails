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

ActiveRecord::Schema[7.0].define(version: 2025_03_22_082352) do
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

  create_table "adminusers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
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
    t.serial "entry_no", null: false
    t.index ["reset_password_token"], name: "index_adminusers_on_reset_password_token", unique: true
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

  create_table "bay_hotels", id: { type: :uuid, default: -> { "gen_random_uuid()" }, comment: "テーブル連番" }, force: :cascade do |t|
    t.string "classify_a", limit: 255, comment: "分類Ａ"
    t.string "classify_b", limit: 255, comment: "分類Ｂ"
    t.string "classify_c", limit: 255, comment: "分類C"
    t.string "title", limit: 255, comment: "タイトル"
    t.string "title_eng", limit: 255, comment: "タイトル英文"
    t.string "case_name", limit: 255, comment: "場合名"
    t.string "part_name", limit: 255, comment: "個別名"
    t.string "case_eng", limit: 255, comment: "場合名英文"
    t.string "speech_no", limit: 255, comment: "台詞番号"
    t.boolean "title_flag_a", default: false, null: false, comment: "タイトルマーク　A"
    t.boolean "title_flag_b", default: false, null: false, comment: "タイトルマーク　B"
    t.boolean "title_flag_c", default: false, null: false, comment: "タイトルマーク　C"
    t.boolean "word_book_flag", default: false, null: false, comment: "単語集マーク"
    t.boolean "title_flag", default: false, null: false, comment: "タイトルマーク"
    t.boolean "case_flag", default: false, null: false, comment: "場合マーク"
    t.boolean "part_flag", default: false, null: false, comment: "個別マーク"
    t.boolean "speech_flag", default: false, null: false, comment: "台詞マーク"
    t.boolean "direct_flag", default: false, null: false, comment: "左右マーク"
    t.boolean "guest_flag", default: false, null: false, comment: "主客マーク"
    t.boolean "image_flag", default: false, null: false, comment: "画像有無"
    t.boolean "audio_flag", default: false, null: false, comment: "音声有無"
    t.boolean "video_flag", default: false, null: false, comment: "動画有無"
    t.text "src_txt", comment: "ソース日語"
    t.text "src_eng", comment: "ソース英語"
    t.text "img_hex", comment: "画像HEX"
    t.text "audio_path", comment: "音声ファイルパス"
    t.text "audio_jpn", comment: "音声日文パス"
    t.text "audio_eng", comment: "音声英文パス"
    t.text "video_path", comment: "動画ファイルパス"
    t.datetime "update_time", precision: nil, default: -> { "now()" }, null: false, comment: "更新日時"
    t.text "audio_jpn_hex", comment: "音声日文BASE64"
    t.text "audio_eng_hex", comment: "音声英文BASE64"
    t.uuid "created_by"
    t.uuid "updated_by"
    t.uuid "deleted_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
  end

  create_table "bay_rooms", id: { type: :uuid, default: -> { "gen_random_uuid()" }, comment: "テーブル連番" }, force: :cascade do |t|
    t.string "classify_a", limit: 255, comment: "分類Ａ"
    t.string "classify_b", limit: 255, comment: "分類Ｂ"
    t.string "classify_c", limit: 255, comment: "分類C"
    t.string "title", limit: 255, comment: "タイトル"
    t.string "room_numb", limit: 255, comment: "部屋番号#あり"
    t.string "room_no", limit: 255, comment: "部屋番号#なし"
    t.boolean "title_flag", default: false, comment: "タイトルマーク"
    t.boolean "room_flag", default: false, comment: "台詞マーク"
    t.boolean "image_flag", default: false, comment: "画像有無"
    t.boolean "audio_flag", default: false, comment: "音声有無"
    t.boolean "video_flag", default: false, comment: "動画有無"
    t.text "room_eng", comment: "部屋番号英語"
    t.text "src_txt", comment: "ソース日語"
    t.text "src_eng", comment: "ソース英語"
    t.text "img_hex", comment: "画像HEX"
    t.text "audio_path", comment: "音声ファイルパス"
    t.text "audio_jpn", comment: "音声日本語パス"
    t.text "video_path", comment: "動画ファイルパス"
    t.datetime "update_time", precision: nil, default: -> { "now()" }, null: false, comment: "更新日時"
  end

  create_table "bay_sheratons", id: { type: :uuid, default: -> { "gen_random_uuid()" }, comment: "テーブル連番" }, force: :cascade do |t|
    t.string "classify_a", limit: 255, comment: "分類Ａ"
    t.string "classify_b", limit: 255, comment: "分類Ｂ"
    t.string "classify_c", limit: 255, comment: "分類C"
    t.string "title", limit: 255, comment: "タイトル"
    t.string "title_eng", limit: 255, comment: "タイトル英文"
    t.string "case_name", limit: 255, comment: "場合名"
    t.string "part_name", limit: 255, comment: "個別名"
    t.string "case_eng", limit: 255, comment: "場合名英文"
    t.string "part_eng", limit: 255, comment: "個別名英文"
    t.string "speech_no", limit: 255, comment: "台詞番号"
    t.boolean "title_flag_a", default: false, null: false, comment: "タイトルマーク　A"
    t.boolean "title_flag_b", default: false, null: false, comment: "タイトルマーク　B"
    t.boolean "title_flag_c", default: false, null: false, comment: "タイトルマーク　C"
    t.boolean "word_book_flag", default: false, null: false, comment: "単語集マーク"
    t.boolean "title_flag", default: false, null: false, comment: "タイトルマーク"
    t.boolean "case_flag", default: false, null: false, comment: "場合マーク"
    t.boolean "part_flag", default: false, null: false, comment: "個別マーク"
    t.boolean "speech_flag", default: false, null: false, comment: "台詞マーク"
    t.boolean "direct_flag", default: false, null: false, comment: "左右マーク"
    t.boolean "guest_flag", default: false, null: false, comment: "主客マーク"
    t.boolean "gender_flag", default: false, null: false, comment: "性別マーク"
    t.boolean "image_flag", default: false, null: false, comment: "画像有無"
    t.boolean "audio_flag", default: false, null: false, comment: "音声有無"
    t.boolean "video_flag", default: false, null: false, comment: "動画有無"
    t.text "src_txt", comment: "ソース日語"
    t.text "src_eng", comment: "ソース英語"
    t.text "com_txt", comment: "コメント日語"
    t.text "com_eng", comment: "コメント英語"
    t.text "img_hex", comment: "画像HEX"
    t.text "audio_path", comment: "音声ファイルパス"
    t.text "audio_jpn", comment: "音声日文パス"
    t.text "audio_eng", comment: "音声英文パス"
    t.text "video_path", comment: "動画ファイルパス"
    t.datetime "update_time", precision: nil, default: -> { "now()" }, null: false, comment: "更新日時"
  end

  create_table "case_guidances", primary_key: "spec_id", id: { type: :serial, comment: "テーブル連番" }, force: :cascade do |t|
    t.integer "prob_no", null: false, comment: "テキスト語彙番号"
    t.string "classify_a", limit: 255, comment: "分類Ａ"
    t.string "classify_b", limit: 255, comment: "分類Ｂ"
    t.string "classify_c", limit: 255, comment: "分類C"
    t.string "prob_title", limit: 255, comment: "問題タイトル"
    t.boolean "example_flag", default: false, comment: "総合問題マーク"
    t.boolean "judge_flag", default: false, comment: "成否マーク"
    t.boolean "image_flag", default: false, comment: "画像有無"
    t.boolean "sound_flag", default: false, comment: "音声有無"
    t.text "src_txt", comment: "問題文ソース"
    t.text "src_eng", comment: "問題文英語"
    t.text "example_txt", comment: "総合問題事例文ソース"
    t.text "example_eng", comment: "総合問題事例文英語"
    t.text "explain_txt", comment: "説明文"
    t.text "explain_en", comment: "説明文英語"
    t.text "key_word", comment: "キーワード"
    t.text "src_hex", comment: "ルビ付きソース"
    t.text "example_hex", comment: "ルビ付き事例文"
    t.text "img_hex", comment: "画像HEX"
    t.text "snd_hex", comment: "音声HEX"
    t.text "explain_hex", comment: "ルビ付き説明文"
    t.datetime "update_time", precision: nil, default: -> { "now()" }, null: false, comment: "更新日時"
    t.jsonb "src_nation", comment: "問題文各国語"
    t.jsonb "example_nation", comment: "総合問題事例文各国語"
    t.jsonb "explain_nation", comment: "説明文各国語"
    t.jsonb "keyword_nation", comment: "キーワード各国語"
    t.jsonb "keyword_compos", comment: "キーワード読み方"
    t.jsonb "src_choice_jp", comment: "選択肢日本文"
    t.jsonb "src_choice_en", comment: "選択肢英文"
    t.jsonb "src_choice_na", comment: "選択肢各国語"
    t.jsonb "exp_choice_jp", comment: "選択肢説明日本文"
    t.jsonb "exp_choice_en", comment: "選択肢説明英文"
    t.jsonb "exp_choice_na", comment: "選択肢説明各国語"
    t.jsonb "src_choice_hex", comment: "選択肢ルビ日本文"
    t.jsonb "exp_choice_hex", comment: "選択肢説明ルビ日本文"
    t.jsonb "src_point_jp", comment: "ガイダンスポイント日語"
    t.jsonb "src_point_en", comment: "ガイダンスポイント英語"
    t.jsonb "src_view_jp", comment: "ガイダンス説明文日語"
    t.jsonb "src_view_en", comment: "ガイダンス説明文英語"
    t.boolean "guidance_flag", default: false, comment: "ガイダンスフラッグ"
    t.text "video_filepath", comment: "動画ファイルパス"
    t.text "audio_filepath", comment: "音声ファイルパス"
    t.text "general_image", comment: "総合ページ画像"
    t.boolean "general_flag", default: false, comment: "総合ページフラッグ"
    t.integer "general_page", comment: "総合ページ番号"
    t.jsonb "src_point_hex", comment: "ガイダンスルビ付きポイント日語"
    t.jsonb "src_view_hex", comment: "ガイダンスルビ付き説明文日語"
  end

  create_table "case_workers", primary_key: "spec_id", id: { type: :serial, comment: "テーブル連番" }, force: :cascade do |t|
    t.integer "prob_no", null: false, comment: "テキスト語彙番号"
    t.string "classify_a", limit: 255, comment: "分類Ａ"
    t.string "classify_b", limit: 255, comment: "分類Ｂ"
    t.string "classify_c", limit: 255, comment: "分類C"
    t.string "prob_title", limit: 255, comment: "問題タイトル"
    t.boolean "example_flag", default: false, comment: "総合問題マーク"
    t.boolean "judge_flag", default: false, comment: "成否マーク"
    t.boolean "image_flag", default: false, comment: "画像有無"
    t.boolean "sound_flag", default: false, comment: "音声有無"
    t.text "src_txt", comment: "問題文ソース"
    t.text "src_eng", comment: "問題文英語"
    t.text "example_txt", comment: "総合問題事例文ソース"
    t.text "example_eng", comment: "総合問題事例文英語"
    t.text "explain_txt", comment: "説明文"
    t.text "explain_en", comment: "説明文英語"
    t.text "key_word", comment: "キーワード"
    t.text "src_hex", comment: "ルビ付きソース"
    t.text "example_hex", comment: "ルビ付き事例文"
    t.text "img_hex", comment: "画像HEX"
    t.text "snd_hex", comment: "音声HEX"
    t.text "explain_hex", comment: "ルビ付き説明文"
    t.datetime "update_time", precision: nil, default: -> { "now()" }, null: false, comment: "更新日時"
    t.jsonb "src_nation", comment: "問題文各国語"
    t.jsonb "example_nation", comment: "総合問題事例文各国語"
    t.jsonb "explain_nation", comment: "説明文各国語"
    t.jsonb "keyword_nation", comment: "キーワード各国語"
    t.jsonb "keyword_compos", comment: "キーワード読み方"
    t.jsonb "src_choice_jp", comment: "選択肢日本文"
    t.jsonb "src_choice_en", comment: "選択肢英文"
    t.jsonb "src_choice_na", comment: "選択肢各国語"
    t.jsonb "exp_choice_jp", comment: "選択肢説明日本文"
    t.jsonb "exp_choice_en", comment: "選択肢説明英文"
    t.jsonb "exp_choice_na", comment: "選択肢説明各国語"
    t.jsonb "src_choice_hex", comment: "選択肢ルビ日本文"
    t.jsonb "exp_choice_hex", comment: "選択肢説明ルビ日本文"
    t.jsonb "src_point_jp", comment: "ガイダンスポイント日語"
    t.jsonb "src_point_en", comment: "ガイダンスポイント英語"
    t.jsonb "src_view_jp", comment: "ガイダンス説明文日語"
    t.jsonb "src_view_en", comment: "ガイダンス説明文英語"
    t.boolean "guidance_flag", default: false, comment: "ガイダンスフラッグ"
    t.text "video_filepath", comment: "動画ファイルパス"
    t.text "audio_filepath", comment: "音声ファイルパス"
    t.text "general_image", comment: "総合ページ画像"
    t.boolean "general_flag", default: false, comment: "総合ページフラッグ"
    t.integer "general_page", comment: "総合ページ番号"
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

  create_table "element_kanjis", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "element_code"
    t.integer "sort", default: 0, null: false
    t.text "kanji_body"
    t.datetime "created_at", default: -> { "now()" }, null: false
    t.datetime "updated_at", default: -> { "now()" }, null: false
    t.datetime "deleted_at"
    t.uuid "created_by"
    t.uuid "updated_by"
    t.uuid "deleted_by"
    t.index ["element_code"], name: "element_kanjis_element_code", unique: true
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

  create_table "kanji_radicals", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "kanji_code"
    t.integer "sort", default: 0, null: false
    t.text "parts_body"
    t.datetime "created_at", default: -> { "now()" }, null: false
    t.datetime "updated_at", default: -> { "now()" }, null: false
    t.datetime "deleted_at"
    t.uuid "created_by"
    t.uuid "updated_by"
    t.uuid "deleted_by"
    t.index ["kanji_code"], name: "kanji_radicals_kanji_code", unique: true
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
    t.boolean "male_flg_old", default: false, null: false
    t.boolean "male_flg"
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

  create_table "read_tables", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "read_code"
    t.integer "sort", default: 0, null: false
    t.text "vocab_body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.uuid "created_by", null: false
    t.uuid "updated_by", null: false
    t.uuid "deleted_by"
  end

  create_table "read_vocabs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "sort", default: 0, null: false
    t.uuid "vocab_table_id", null: false
    t.uuid "read_table_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.uuid "created_by", null: false
    t.uuid "updated_by", null: false
    t.uuid "deleted_by"
    t.index ["read_table_id"], name: "index_read_vocabs_on_read_table_id"
    t.index ["vocab_table_id"], name: "index_read_vocabs_on_vocab_table_id"
  end

  create_table "specified_vocab_as", id: { type: :uuid, default: -> { "gen_random_uuid()" }, comment: "各エントリの一意識別子" }, force: :cascade do |t|
    t.uuid "department_id", null: false, comment: "部署ID"
    t.string "title", null: false, comment: "タイトル"
    t.integer "sort", comment: "ソート順"
    t.string "content", comment: "コンテンツ"
    t.text "src_jpn", comment: "日本語のソース"
    t.text "src_eng", comment: "英語のソース"
    t.jsonb "src_nation", comment: "各国のソース"
    t.uuid "created_by", null: false
    t.uuid "updated_by", null: false
    t.uuid "deleted_by"
    t.datetime "created_at", null: false, comment: "エントリ作成時のタイムスタンプ"
    t.datetime "updated_at", null: false, comment: "エントリが最後に更新された時のタイムスタンプ"
    t.datetime "deleted_at", comment: "エントリが削除された時のタイムスタンプ"
  end

  create_table "specified_vocab_bs", id: { type: :uuid, default: -> { "gen_random_uuid()" }, comment: "各エントリの一意識別子" }, force: :cascade do |t|
    t.uuid "specified_vocab_a_id", comment: "関連する指定語彙AのID"
    t.string "word", limit: 100, null: false, comment: "語彙（漢字、かな、またはその両方）"
    t.string "reading", limit: 100, comment: "語彙の読み方（かな）"
    t.json "meaning_nation", comment: "語彙の意味（英語または他のターゲット言語）"
    t.json "example_sentence_nation", comment: "語彙を使用した例文"
    t.integer "level", comment: "語彙の出題レベル"
    t.string "jlpt", limit: 50, comment: "語彙の難易度レベル（例：初級、中級、上級）"
    t.integer "frequency_count", comment: "語彙の使用頻度"
    t.string "category", limit: 100, comment: "語彙のカテゴリまたはコンテキスト（例：宿泊、観光、ホスピタリティ）"
    t.uuid "created_by", null: false
    t.uuid "updated_by", null: false
    t.uuid "deleted_by"
    t.datetime "created_at", default: -> { "now()" }, null: false, comment: "エントリ作成時のタイムスタンプ"
    t.datetime "updated_at", default: -> { "now()" }, null: false, comment: "エントリが最後に更新された時のタイムスタンプ"
    t.datetime "deleted_at", comment: "エントリが削除された時のタイムスタンプ"
  end

  create_table "ssw_expllimbs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "ssw_expl_id", null: false
    t.string "expllimb_code", null: false
    t.text "expllimb_txt", null: false
    t.text "expllimb_eng"
    t.jsonb "expllimb_nation"
    t.integer "sort", default: 0, comment: "ケース名のソート順"
    t.boolean "judge_flag"
    t.boolean "image_flag"
    t.boolean "sound_flag"
    t.text "expllimb_hex"
    t.text "img_hex"
    t.text "snd_hex"
    t.datetime "created_at", default: -> { "now()" }, null: false, comment: "作成日時と更新日時"
    t.datetime "updated_at", default: -> { "now()" }, null: false, comment: "作成日時と更新日時"
    t.datetime "deleted_at", comment: "削除日時"
    t.uuid "created_by", comment: "作成者"
    t.uuid "updated_by", comment: "更新者"
    t.uuid "deleted_by", comment: "削除者"
    t.index ["ssw_expl_id", "sort"], name: "ssw_expllimbs_ssw_expl_id_sort", unique: true
  end

  create_table "ssw_expls", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "ssw_prob_id", null: false
    t.text "expl_txt", null: false
    t.text "expl_eng"
    t.jsonb "expl_nation"
    t.integer "sort", default: 0, comment: "ケース名のソート順"
    t.boolean "judge_flag"
    t.boolean "image_flag"
    t.boolean "sound_flag"
    t.text "expl_hex"
    t.text "img_hex"
    t.text "snd_hex"
    t.datetime "created_at", default: -> { "now()" }, null: false, comment: "作成日時と更新日時"
    t.datetime "updated_at", default: -> { "now()" }, null: false, comment: "作成日時と更新日時"
    t.datetime "deleted_at", comment: "削除日時"
    t.uuid "created_by", comment: "作成者"
    t.uuid "updated_by", comment: "更新者"
    t.uuid "deleted_by", comment: "削除者"
    t.index ["ssw_prob_id", "expl_txt"], name: "ssw_expls_ssw_prob_id_expl_txt", unique: true
  end

  create_table "ssw_plans", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "app_code", null: false
    t.string "plan_name", null: false
    t.string "plan_eng"
    t.jsonb "plan_nation"
    t.integer "sort", comment: "ソート"
    t.datetime "created_at", default: -> { "now()" }, null: false, comment: "作成日時と更新日時"
    t.datetime "updated_at", default: -> { "now()" }, null: false, comment: "作成日時と更新日時"
    t.datetime "deleted_at", comment: "削除日時"
    t.uuid "created_by", comment: "作成者"
    t.uuid "updated_by", comment: "更新者"
    t.uuid "deleted_by", comment: "削除者"
    t.string "company"
    t.index ["app_code"], name: "ssw_plans_app_code", unique: true
  end

  create_table "ssw_problimbs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "ssw_prob_id", null: false
    t.string "problimb_code", null: false
    t.text "problimb_txt", null: false
    t.text "problimb_eng"
    t.jsonb "problimb_nation"
    t.integer "sort", default: 0, comment: "ケース名のソート順"
    t.boolean "judge_flag"
    t.boolean "image_flag"
    t.boolean "sound_flag"
    t.text "problimb_hex"
    t.text "img_hex"
    t.text "snd_hex"
    t.datetime "created_at", default: -> { "now()" }, null: false, comment: "作成日時と更新日時"
    t.datetime "updated_at", default: -> { "now()" }, null: false, comment: "作成日時と更新日時"
    t.datetime "deleted_at", comment: "削除日時"
    t.uuid "created_by", comment: "作成者"
    t.uuid "updated_by", comment: "更新者"
    t.uuid "deleted_by", comment: "削除者"
    t.index ["ssw_prob_id", "sort"], name: "ssw_problimbs_ssw_prob_id_sort", unique: true
  end

  create_table "ssw_probs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "ssw_title_id", null: false
    t.text "prob_txt", null: false
    t.text "prob_eng"
    t.jsonb "prob_nation"
    t.integer "sort", default: 0, comment: "ケース名のソート順"
    t.boolean "judge_flag", default: false
    t.boolean "image_flag"
    t.boolean "sound_flag"
    t.text "prob_hex"
    t.text "img_hex"
    t.text "snd_hex"
    t.datetime "created_at", default: -> { "now()" }, null: false, comment: "作成日時と更新日時"
    t.datetime "updated_at", default: -> { "now()" }, null: false, comment: "作成日時と更新日時"
    t.datetime "deleted_at", comment: "削除日時"
    t.uuid "created_by", comment: "作成者"
    t.uuid "updated_by", comment: "更新者"
    t.uuid "deleted_by", comment: "削除者"
    t.integer "sfx_num", default: 0, comment: "選択技の数"
    t.index ["ssw_title_id", "prob_txt"], name: "ssw_probs_ssw_title_id_prob_txt", unique: true
  end

  create_table "ssw_titleas", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "ssw_plan_id", null: false
    t.string "titlea_code", null: false, comment: "ソート用コード名"
    t.string "titlea_name", null: false
    t.string "titlea_eng"
    t.jsonb "titlea_nation"
    t.integer "sort", comment: "ソート"
    t.datetime "created_at", default: -> { "now()" }, null: false, comment: "作成日時と更新日時"
    t.datetime "updated_at", default: -> { "now()" }, null: false, comment: "作成日時と更新日時"
    t.datetime "deleted_at", comment: "削除日時"
    t.uuid "created_by", comment: "作成者"
    t.uuid "updated_by", comment: "更新者"
    t.uuid "deleted_by", comment: "削除者"
    t.string "company"
    t.index ["ssw_plan_id", "titlea_code"], name: "ssw_titleas_ssw_plan_id_titlea_code", unique: true
  end

  create_table "ssw_titlebs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "ssw_titlea_id", null: false
    t.string "titleb_code", null: false, comment: "ソート用コード名"
    t.string "titleb_name", null: false
    t.string "titleb_eng"
    t.jsonb "titleb_nation"
    t.integer "sort", comment: "ソート"
    t.datetime "created_at", default: -> { "now()" }, null: false, comment: "作成日時と更新日時"
    t.datetime "updated_at", default: -> { "now()" }, null: false, comment: "作成日時と更新日時"
    t.datetime "deleted_at", comment: "削除日時"
    t.uuid "created_by", comment: "作成者"
    t.uuid "updated_by", comment: "更新者"
    t.uuid "deleted_by", comment: "削除者"
    t.index ["ssw_titlea_id", "titleb_code"], name: "ssw_titlebs_ssw_titlea_id_titleb_code", unique: true
  end

  create_table "ssw_titlecs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "ssw_titleb_id", null: false
    t.string "titlec_code", null: false, comment: "ソート用コード名"
    t.string "titlec_name", null: false
    t.string "titlec_eng"
    t.jsonb "titlec_nation"
    t.integer "sort"
    t.datetime "created_at", default: -> { "now()" }, null: false, comment: "作成日時と更新日時"
    t.datetime "updated_at", default: -> { "now()" }, null: false, comment: "作成日時と更新日時"
    t.datetime "deleted_at", comment: "削除日時"
    t.uuid "created_by", comment: "作成者"
    t.uuid "updated_by", comment: "更新者"
    t.uuid "deleted_by", comment: "削除者"
    t.index ["ssw_titleb_id", "titlec_code"], name: "ssw_titlecs_ssw_titleb_id_titlec_code", unique: true
  end

  create_table "ssw_titles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "ssw_titlec_id", null: false
    t.string "title_code", null: false, comment: "ソート用コード名"
    t.string "title_name", null: false
    t.string "title_eng"
    t.jsonb "title_nation"
    t.integer "sort", comment: "ケース名のソート順"
    t.boolean "title_flag", default: true
    t.datetime "created_at", default: -> { "now()" }, null: false, comment: "作成日時と更新日時"
    t.datetime "updated_at", default: -> { "now()" }, null: false, comment: "作成日時と更新日時"
    t.datetime "deleted_at", comment: "削除日時"
    t.uuid "created_by", comment: "作成者"
    t.uuid "updated_by", comment: "更新者"
    t.uuid "deleted_by", comment: "削除者"
    t.integer "app_code", default: 0, null: false, comment: "会社許可コード"
    t.index ["ssw_titlec_id", "title_code"], name: "ssw_titles_ssw_titlec_id_title_code", unique: true
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
    t.integer "entry_no", default: 0, null: false
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
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
    t.index ["vocab_table_id"], name: "index_vocab_nations_on_vocab_table_id"
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
    t.string "vocab_explain", comment: "語彙説明（英語）"
    t.index ["vocab_org"], name: "index_vocab_stores_on_vocab_org", unique: true
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
    t.integer "jlpt_level", default: 0, null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "audio_bs", "audio_as"
  add_foreign_key "audio_c_contents", "audio_cs"
  add_foreign_key "audio_cs", "audio_bs"
  add_foreign_key "audio_ds", "audio_c_contents"
  add_foreign_key "company_store_contents", "company_stores"
  add_foreign_key "company_stores", "comps"
  add_foreign_key "job_profile_contents", "job_profiles"
  add_foreign_key "job_profiles", "comps"
  add_foreign_key "kanji_vocabs", "vocab_tables", name: "kanji_vocabs_vocab_table_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "parts_kanjis", "parts_tables", name: "parts_kanjis_parts_table_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "profile_languages", "profiles"
  add_foreign_key "profile_works", "profiles"
  add_foreign_key "profiles", "users"
  add_foreign_key "read_vocabs", "read_tables"
  add_foreign_key "read_vocabs", "vocab_tables"
  add_foreign_key "ssw_expllimbs", "ssw_expls", name: "ssw_expllimbs_ssw_expl_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "ssw_expls", "ssw_probs", name: "ssw_expls_ssw_prob_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "ssw_problimbs", "ssw_probs", name: "ssw_problimbs_ssw_prob_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "ssw_titleas", "ssw_plans", name: "ssw_titleas_ssw_plan_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "ssw_titlebs", "ssw_titleas", name: "ssw_titlebs_ssw_titlea_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "ssw_titlecs", "ssw_titlebs", name: "ssw_titlecs_ssw_titleb_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "ssw_titles", "ssw_titlecs", name: "ssw_titles_ssw_titlec_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "store_contents", "stores", name: "store_contents_store_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "stores", "users", name: "stores_user_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "tokutei_answers", "tokutei_questions"
  add_foreign_key "tokutei_questions", "tokuteis"
  add_foreign_key "tokuteis", "tokuteis"
  add_foreign_key "vocab_mycards", "users", name: "vocab_mycards_user_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "vocab_mycards", "vocab_tables"
  add_foreign_key "vocab_nations", "vocab_tables"
end
