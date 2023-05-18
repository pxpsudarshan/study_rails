class CreateCompanyMajorStores < ActiveRecord::Migration[7.0]
  def change
    create_table :company_major_stores, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.string :company_code
      t.string :occupation
      t.jsonb :vocab_achievement
      t.jsonb :vocab_recommended
      t.operator_stamps

      t.timestamps
      t.datetime :deleted_at
    end
  end
end
