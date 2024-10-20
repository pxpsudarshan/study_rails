class CreateSpecifiedVocabBs < ActiveRecord::Migration[7.0]
  def change
    create_table :specified_vocab_bs, id: :uuid do |t|
      t.uuid :specified_vocab_a_id
      t.string :word, limit: 100, null: false
      t.string :reading, limit: 100
      t.json :meaning_nation, null: false
      t.json :example_sentence_nation
      t.integer :level
      t.string :jlpt, limit: 50
      t.integer :frequency_count
      t.string :category, limit: 100
      t.operator_stamps

      t.timestamps
      t.datetime :deleted_at
    end

    # Adding comments for specified_vocab_bs table columns
    execute <<-SQL
      COMMENT ON COLUMN specified_vocab_bs.id IS '各エントリの一意識別子';
      COMMENT ON COLUMN specified_vocab_bs.specified_vocab_a_id IS '関連する指定語彙AのID';
      COMMENT ON COLUMN specified_vocab_bs.word IS '語彙（漢字、かな、またはその両方）';
      COMMENT ON COLUMN specified_vocab_bs.reading IS '語彙の読み方（かな）';
      COMMENT ON COLUMN specified_vocab_bs.meaning_nation IS '語彙の意味（英語または他のターゲット言語）';
      COMMENT ON COLUMN specified_vocab_bs.example_sentence_nation IS '語彙を使用した例文';
      COMMENT ON COLUMN specified_vocab_bs.level IS '語彙の出題レベル';
      COMMENT ON COLUMN specified_vocab_bs.jlpt IS '語彙の難易度レベル（例：初級、中級、上級）';
      COMMENT ON COLUMN specified_vocab_bs.frequency_count IS '語彙の使用頻度';
      COMMENT ON COLUMN specified_vocab_bs.category IS '語彙のカテゴリまたはコンテキスト（例：宿泊、観光、ホスピタリティ）';
      COMMENT ON COLUMN specified_vocab_bs.created_at IS 'エントリ作成時のタイムスタンプ';
      COMMENT ON COLUMN specified_vocab_bs.updated_at IS 'エントリが最後に更新された時のタイムスタンプ';
      COMMENT ON COLUMN specified_vocab_bs.deleted_at IS 'エントリが削除された時のタイムスタンプ';
    SQL

  end
end
