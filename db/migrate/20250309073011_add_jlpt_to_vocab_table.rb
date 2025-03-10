class AddJlptToVocabTable < ActiveRecord::Migration[7.0]
  def change
    add_column :vocab_tables, :jlpt_level, :integer, null: false, default: 0
  end
end
