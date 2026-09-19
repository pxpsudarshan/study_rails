class RenameCallKanaToNameKanaInProfiles < ActiveRecord::Migration[7.0]
  def change
    rename_column :profiles, :call_name, :name_kana
  end
end