class CreateJobProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :job_profiles, id: :uuid do |t|
      t.references :comp, null: false, foreign_key: true, type: :uuid
      t.operator_stamps

      t.timestamps
      t.datetime :deleted_at
    end
  end
end
