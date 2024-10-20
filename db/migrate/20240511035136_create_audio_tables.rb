class CreateAudioTables < ActiveRecord::Migration[7.0]
  def change
    create_table :audio_as, id: :uuid, default: -> { "gen_random_uuid()" }, comment: "会話のタイトルを格納するテーブル" do |t|
      t.jsonb :title_nation, comment: "タイトルの国別情報"
      t.integer :sort, comment: "ソート"
      t.timestamps null: false, default: -> { "now()" }, comment: "作成日時と更新日時"
      t.datetime :deleted_at, comment: "削除日時"
      t.uuid :created_by, null: false, comment: "作成者"
      t.uuid :updated_by, null: false, comment: "更新者"
      t.uuid :deleted_by, comment: "削除者"
    end

    create_table :audio_bs, id: :uuid, default: -> { "gen_random_uuid()" }, comment: "音声の経路情報を格納するテーブル" do |t|
      t.references :audio_a, type: :uuid, foreign_key: true, null: false
      t.integer :sort, comment: "ソート"
      t.jsonb :title_nation, comment: "タイトルの国別情報"
      t.timestamps null: false, default: -> { "now()" }, comment: "作成日時と更新日時"
      t.datetime :deleted_at, comment: "削除日時"
      t.uuid :created_by, null: false, comment: "作成者"
      t.uuid :updated_by, null: false, comment: "更新者"
      t.uuid :deleted_by, comment: "削除者"
    end

    create_table :audio_cs, id: :uuid, default: -> { "gen_random_uuid()" }, comment: "音声を格納するテーブル" do |t|
      t.references :audio_b, type: :uuid, foreign_key: true, null: false, comment: "関連するaudio_bテーブルのレコードのID"
      t.jsonb :title_nation, comment: "国別情報（JSON形式）"
      t.jsonb :case_name_nation, comment: "ケース名の国別情報"
      t.integer :title_sort, comment: "ケース名のソート順"
      t.integer :case_name_sort, comment: "ケース名のソート順"
      t.timestamps null: false, default: -> { "now()" }, comment: "作成日時と更新日時"
      t.datetime :deleted_at, comment: "削除日時"
      t.uuid :created_by, null: false, comment: "作成者"
      t.uuid :updated_by, null: false, comment: "更新者"
      t.uuid :deleted_by, comment: "削除者"
    end

    create_table :audio_ds, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.references :audio_c, type: :uuid, foreign_key: true, null: false, comment: "関連するaudio_bテーブルのレコードのID"
      t.integer :sort, comment: "ケース名のソート順"
      t.boolean :customer_flag, default: false, null: false, comment: "顧客フラグ"
      t.string :lang, null: false
      t.string :content, null: false
      t.timestamps null: false, default: -> { "now()" }, comment: "作成日時と更新日時"
      t.datetime :deleted_at, comment: "削除日時"
      t.uuid :created_by, null: false, comment: "作成者"
      t.uuid :updated_by, null: false, comment: "更新者"
      t.uuid :deleted_by, comment: "削除者"
    end

    add_index :audio_bs, [:audio_a_id, :id], name: "index_audio_bs_on_audio_a_id_and_audio_bs_id"
    add_index :audio_cs, [:audio_b_id, :id], name: "index_audio_cs_on_audio_b_id_and_audio_cs_id"
    add_index :audio_ds, [:audio_c_id, :id], name: "index_audio_ds_on_audio_c_id_and_audio_ds_id"
  end
end
