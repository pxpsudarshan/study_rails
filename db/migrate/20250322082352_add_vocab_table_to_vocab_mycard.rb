class AddVocabTableToVocabMycard < ActiveRecord::Migration[7.0]
  def change
    VocabMycard.delete_all!
    add_reference :vocab_mycards, :vocab_table, null: false, foreign_key: true, type: :uuid
    remove_column :vocab_mycards, :vocab_mycard_org, :integer
    remove_column :vocab_mycards, :vocab_org, :integer, null: false
    remove_column :vocab_mycards, :vocab_code, :string, null: false
    remove_column :vocab_mycards, :vocab_read, :string
    remove_column :vocab_mycards, :kanji_body, :text
    remove_column :vocab_mycards, :jlpt_class, :integer
    remove_column :vocab_mycards, :jlpt_level, :string
    remove_column :vocab_mycards, :parts_body, :text
    remove_column :vocab_mycards, :recent_date, :date
  end
end
