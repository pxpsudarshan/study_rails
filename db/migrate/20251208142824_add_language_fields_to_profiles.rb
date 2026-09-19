class AddLanguageFieldsToProfiles < ActiveRecord::Migration[7.0]
  def change
    add_column :profiles, :japanese_level, :integer
    add_column :profiles, :english_level, :integer
    add_column :profiles, :toeic_score, :integer
  end
end
