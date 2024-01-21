class AddSpecialMycardLevelToSpecifiedSkills < ActiveRecord::Migration[6.0]
  def change
    add_column :specified_skills, :special_mycard_level, :integer, default: 0
  end
end
