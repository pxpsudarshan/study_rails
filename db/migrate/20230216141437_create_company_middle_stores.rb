class CreateCompanyMiddleStores < ActiveRecord::Migration[7.0]
  def change
    create_table :company_middle_stores, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.string :company_code
      t.string :occupation
      t.string :vocab_code
      t.string :vocab_read
      t.string :vocab_mean
      t.operator_stamps

      t.timestamps
      t.datetime :deleted_at
    end
  end
end
