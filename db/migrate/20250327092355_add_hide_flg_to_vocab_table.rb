class AddHideFlgToVocabTable < ActiveRecord::Migration[7.0]
  def change
    add_column :vocab_tables, :hide_flg, :boolean, null: false, default: false
  end
end
