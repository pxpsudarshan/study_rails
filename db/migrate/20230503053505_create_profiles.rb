class CreateProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :profiles, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.string :call_name
      t.integer :kokuseki
      t.date :birthday
      t.integer :sex
      t.boolean :injapan_flg, null: false, default: false
      t.text :address
      t.integer :visa_type
      t.date :visa_end_date
      t.date :desired_work_date

      t.integer :jp_school_type
      t.date :jp_school_date
      t.integer :jp_school_end
      t.string :jp_school_senko
      t.string :jp_school_name

      t.integer :school_type
      t.date :school_date
      t.integer :school_end
      t.string :school_senko
      t.string :school_name

      t.text :skill

      t.operator_stamps

      t.timestamps
      t.datetime :deleted_at
    end
  end
end
