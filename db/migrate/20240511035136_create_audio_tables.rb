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

    add_index :audio_ds, [:audio_c_id, :id], name: "index_audio_ds_on_audio_c_id_and_audio_ds_id"
  end
end
