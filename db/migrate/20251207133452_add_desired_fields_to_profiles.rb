class AddDesiredFieldsToProfiles < ActiveRecord::Migration[7.0]
  def change
    add_column :profiles, :desired_job_type, :integer
    add_column :profiles, :desired_industry, :integer
    add_column :profiles, :desired_work_place, :integer
  end
end
