class CreateStoreContents < ActiveRecord::Migration[7.0]
  def change
    create_table :store_contents, id: :uuid do |t|
      t.references :store, null: false, foreign_key: true, type: :uuid
      t.string :user_code
      t.string :jlpt_class
      t.string :vocab_code
      t.string :vocab_read
      t.string :vocab_mean
      t.integer :use
      t.operator_stamps

      t.timestamps
      t.datetime :deleted_at
    end
  end
end
