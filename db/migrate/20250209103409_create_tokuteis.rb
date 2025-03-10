class CreateTokuteis < ActiveRecord::Migration[7.0]
  def change
    create_table :tokuteis, id: :uuid do |t|
      t.references :tokutei, null: true, foreign_key: true, type: :uuid
      t.string :title, null: false
      t.integer :sort, null: false, default: 0
      t.integer :code, null: false, default: 0
      t.operator_stamps

      t.timestamps
      t.datetime :deleted_at
    end
  end
end
