class CreateVocabStores < ActiveRecord::Migration[7.0]
  def change
    create_table :vocab_stores, id: :uuid do |t|
      t.integer :vocab_org, null: false
      t.string :vocab_code, null: false
      t.integer :vocab_num
      t.string :vocab_read
      t.string :unit_sheet
      t.string :kanji_sheet
      t.jsonb :vocab_kanji
      t.jsonb :nation_vocab, default: {}
      t.integer :jlpt_class, default: 0
      t.string :jlpt_level
      t.integer :vocab_seq, default: 0
      t.boolean :excel_flag, null: false, default: false
      t.text :genre
      t.boolean :active_sign, null: false, default: true
      t.operator_stamps

      t.timestamps
      t.datetime :deleted_at
    end
  end
end
