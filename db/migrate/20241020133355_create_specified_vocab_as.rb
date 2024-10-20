class CreateSpecifiedVocabAs < ActiveRecord::Migration[7.0]
  def change
    create_table :specified_vocab_as, id: :uuid do |t|
      t.uuid :department_id, null: false
      t.string :title, null: false
      t.integer :sort
      t.string :content
      t.text :src_jpn
      t.text :src_eng
      t.jsonb :src_nation
      t.operator_stamps

      t.timestamps
      t.datetime :deleted_at
    end

    # Adding comments for specified_vocab_as table columns
    execute <<-SQL
      COMMENT ON COLUMN specified_vocab_as.id IS '各エントリの一意識別子';
      COMMENT ON COLUMN specified_vocab_as.department_id IS '部署ID';
      COMMENT ON COLUMN specified_vocab_as.title IS 'タイトル';
      COMMENT ON COLUMN specified_vocab_as.sort IS 'ソート順';
      COMMENT ON COLUMN specified_vocab_as.content IS 'コンテンツ';
      COMMENT ON COLUMN specified_vocab_as.src_jpn IS '日本語のソース';
      COMMENT ON COLUMN specified_vocab_as.src_eng IS '英語のソース';
      COMMENT ON COLUMN specified_vocab_as.src_nation IS '各国のソース';
      COMMENT ON COLUMN specified_vocab_as.created_at IS 'エントリ作成時のタイムスタンプ';
      COMMENT ON COLUMN specified_vocab_as.updated_at IS 'エントリが最後に更新された時のタイムスタンプ';
      COMMENT ON COLUMN specified_vocab_as.deleted_at IS 'エントリが削除された時のタイムスタンプ';
    SQL

  end
end
