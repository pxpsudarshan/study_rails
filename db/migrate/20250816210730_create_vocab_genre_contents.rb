class CreateVocabGenreContents < ActiveRecord::Migration[7.0]
  def change
    create_table :vocab_genre_contents, id: :uuid do |t|
      t.references :vocab_genre, null: false, foreign_key: true, type: :uuid
      t.references :vocab_table, null: false, foreign_key: true, type: :uuid
      t.boolean :hide_flg, null: false, default: false
      t.integer :sort, null: false, default: 0
      t.operator_stamps

      t.timestamps
      t.datetime :deleted_at
    end
    remove_column :vocab_genres, :vocab_table_id, :uuid, null: false
  end
end
