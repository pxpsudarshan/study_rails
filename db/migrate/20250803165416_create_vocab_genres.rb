class CreateVocabGenres < ActiveRecord::Migration[7.0]
  def change
    create_table :vocab_genres, id: :uuid do |t|
      t.references :vocab_table, null: false, foreign_key: true, type: :uuid
      t.references :vocab_genre, null: true, foreign_key: true, type: :uuid
      t.string :title, null: false
      t.integer :sort, null: false, default: 0
      t.boolean :hide_flg, null: false, default: false
      t.operator_stamps

      t.timestamps
      t.datetime :deleted_at
    end
  end
end
