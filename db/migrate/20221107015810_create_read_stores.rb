class CreateReadStores < ActiveRecord::Migration[7.0]
  def change
    create_table :read_stores, id: :uuid do |t|
      t.integer :read_org, null: false
      t.string :read_code, null: false
      t.integer :vocab_org, null: false
      t.string :vocab_code, null: false
      t.jsonb :read_vocab
      t.operator_stamps

      t.timestamps
      t.datetime :deleted_at
    end
  end
end
