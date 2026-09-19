class AddNativeLanguageToProfiles < ActiveRecord::Migration[7.0]
  def change
    add_column :profiles, :native_language, :string
  end
end
