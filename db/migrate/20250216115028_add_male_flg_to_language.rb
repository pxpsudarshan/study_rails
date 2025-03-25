class AddMaleFlgToLanguage < ActiveRecord::Migration[7.0]
  def change
    add_column :languages, :male_flg, :boolean, null: false, default: false
  end
end
