class CreateProfileWorks < ActiveRecord::Migration[7.0]
  def change
    create_table :profile_works, id: :uuid do |t|
      t.references :profile, null: false, foreign_key: true, type: :uuid
      t.integer :work_country
      t.string :work_place
      t.string :work_type
      t.date :start_date
      t.date :end_date
      t.operator_stamps

      t.timestamps
      t.datetime :deleted_at
    end
  end
end
