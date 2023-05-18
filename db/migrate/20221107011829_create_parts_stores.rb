class CreatePartsStores < ActiveRecord::Migration[7.0]
  def change
    create_table :parts_stores, id: :uuid do |t|
      t.integer :parts_org, null: false
      t.string :parts_code, null: false
      t.integer :parts_stroke
      t.jsonb :parts_kanji
      t.text :kanji_body
      t.operator_stamps

      t.timestamps
      t.datetime :deleted_at
    end
  end
end
