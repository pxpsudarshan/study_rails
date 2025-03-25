class CreateTableKanjis < ActiveRecord::Migration[7.0]
  def change
    create_table :parts_tables, id: :uuid do |t|
      t.string :parts_code
      t.integer :parts_stroke
      t.integer :sort, null: false, default: 0
      t.text :kanji_body
      t.timestamps
      t.datetime :deleted_at
      t.operator_stamps
    end
    create_table :kanji_tables, id: :uuid do |t|
      t.string :kanji_code
      t.integer :sort, null: false, default: 0
      t.string :parts_body
      t.text :vocab_body
      t.timestamps
      t.datetime :deleted_at
      t.operator_stamps
    end
    create_table :parts_kanjis, id: :uuid do |t|
      t.integer :sort, null: false, default: 0
      t.references :parts_table, null: false, foreign_key: true, type: :uuid
      t.references :kanji_table, null: false, foreign_key: true, type: :uuid
      t.timestamps
      t.datetime :deleted_at
      t.operator_stamps
    end
    create_table :vocab_tables, id: :uuid do |t|
      t.string :vocab_code
      t.integer :sort, null: false, default: 0
      t.integer :kanji_numb
      t.text :kanji_body
      t.string :vocab_read
      t.timestamps
      t.datetime :deleted_at
      t.operator_stamps
    end
    create_table :kanji_vocabs, id: :uuid do |t|
      t.integer :sort, null: false, default: 0
      t.references :kanji_table, null: false, foreign_key: true, type: :uuid
      t.references :vocab_table, null: false, foreign_key: true, type: :uuid
      t.timestamps
      t.datetime :deleted_at
      t.operator_stamps
    end
    create_table :vocab_nations, id: :uuid do |t|
      t.references :vocab_table, null: false, foreign_key: true, type: :uuid
      t.integer :sort, null: false, default: 0
      t.string :lang
      t.text :nation_code
      t.timestamps
      t.datetime :deleted_at
      t.operator_stamps
    end
#    create_table :read_tables, id: :uuid do |t|
#      t.string :read_code
#      t.integer :sort, null: false, default: 0
#      t.text :vocab_body
#      t.timestamps
#      t.datetime :deleted_at
#      t.operator_stamps
#    end
#    create_table :read_vocabs, id: :uuid do |t|
#      t.integer :sort, null: false, default: 0
#      t.references :vocab_table, null: false, foreign_key: true, type: :uuid
#      t.references :read_table, null: false, foreign_key: true, type: :uuid
#      t.timestamps
#      t.datetime :deleted_at
#      t.operator_stamps
#    end
    add_index :parts_tables, :parts_code, unique: true
    add_index :kanji_tables, :kanji_code, unique: true
    add_index :vocab_tables, :vocab_code, unique: true
#    add_index :read_tables,  :read_code, unique: true
  end
end
