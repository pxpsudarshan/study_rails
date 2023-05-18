class CreateKanjiStores < ActiveRecord::Migration[7.0]
  def change
    create_table :kanji_stores, id: :uuid do |t|
      t.integer :kanji_org, null: false
      t.string :kanji_code, null: false
      t.integer :kanji_no
      t.jsonb :kanji_vocab
      t.string :unit_sheet
      t.jsonb :kanji_parts
      t.text :parts_body
      t.operator_stamps

      t.timestamps
      t.datetime :deleted_at
    end
  end
end
