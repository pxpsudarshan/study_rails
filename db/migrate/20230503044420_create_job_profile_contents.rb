class CreateJobProfileContents < ActiveRecord::Migration[7.0]
  def change
    create_table :job_profile_contents, id: :uuid do |t|
      t.references :job_profile, null: false, foreign_key: true, type: :uuid
      t.integer :employment_sts
      t.integer :occupation, null: false, default: 0
      t.string :ad_title
      t.integer :salary, null: false, default: 0
      t.integer :location, array: true, null: false, default: []
      t.boolean :visa_support, null: false, default: false
      t.integer :visa_type, null: false, default: 0
      t.integer :year, null: false, default: 1970
      t.integer :month, array: true, null: false, default: []
      t.text :job_description
      t.text :desire_qualification
      t.operator_stamps

      t.timestamps
      t.datetime :deleted_at
    end
  end
end
