class AddStudentProfiles < ActiveRecord::Migration[7.0]
  def change
    add_column :student_profiles, :lang_id, :string, null: false, default: 'EN'
    add_column :users, :mycard_sign, :boolean, default: false, null: false
  end
end
