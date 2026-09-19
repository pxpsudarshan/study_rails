class AddExampleToVocabTable < ActiveRecord::Migration[7.0]
  def change
    add_column :vocab_tables, :example, :text
    add_column :vocab_nations, :example, :text
  end
end
