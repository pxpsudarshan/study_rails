class AddItemsToVocabStore < ActiveRecord::Migration[7.0]
  def change
    add_column :vocab_stores, :vocab_explain, :string
    add_column :vocab_mycards, :mycard_level, :integer, null: false, default: 0
  end
end
