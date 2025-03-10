class AddMaleFlgToLanguage < ActiveRecord::Migration[7.0]
  def change
    add_column :languages, :male_flg, :boolean
  end
end
