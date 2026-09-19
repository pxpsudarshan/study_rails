class CreateProfileQualifications < ActiveRecord::Migration[7.0]
  def change
    create_table :profile_qualifications, id: :uuid do |t|
      t.references :profile, null: false, foreign_key: true, type: :uuid
      t.integer :achieved_year  # 取得年
      t.integer :achieved_month  # 取得月
      t.string  :qualification_name  # 資格名（例：基本情報技術者）
      t.operator_stamps

      t.timestamps
      t.datetime :deleted_at
    end
  end
end
