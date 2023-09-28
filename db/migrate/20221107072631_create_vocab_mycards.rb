class CreateVocabMycards < ActiveRecord::Migration[7.0]
  def change
    create_table :vocab_mycards, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.integer :vocab_mycard_org
      t.integer :vocab_org, null: false
      t.string :vocab_code, null: false
      t.string :vocab_read
      t.text :kanji_body
      t.integer :jlpt_class
      t.string :jlpt_level
      t.text :parts_body
      t.date :recent_date
      t.integer :mycard_check
      t.operator_stamps

      t.timestamps
      t.datetime :deleted_at
    end
  end
end
