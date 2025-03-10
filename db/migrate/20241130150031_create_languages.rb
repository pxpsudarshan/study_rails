class CreateLanguages < ActiveRecord::Migration[7.0]
  def change
    create_table :languages, id: :uuid do |t|
      t.references :langs, polymorphic: true, null: false, type: :uuid
      t.text :content
      t.string :language, null: false
      t.integer :sort, null: false, default: 0
      t.operator_stamps

      t.timestamps
      t.datetime :deleted_at
    end
  end
end
