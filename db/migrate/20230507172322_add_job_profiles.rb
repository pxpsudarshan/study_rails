class AddJobProfiles < ActiveRecord::Migration[7.0]
  def change
    add_column :job_profiles, :visa_type, :integer
  end
end
