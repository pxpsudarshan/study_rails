class CreateStores < ActiveRecord::Migration[7.0]
  def change
    create_table :stores, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.operator_stamps

      t.timestamps
      t.datetime :deleted_at
    end
  end
end
