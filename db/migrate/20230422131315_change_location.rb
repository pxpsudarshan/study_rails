class ChangeLocation < ActiveRecord::Migration[7.0]
  def up
    change_column :job_profiles, :location, :integer, array: true, using: 'ARRAY[location]::INTEGER[]'
  end

  def down
    change_column :job_profiles, :location, :integer, using: 'location::integer'
  end
end
