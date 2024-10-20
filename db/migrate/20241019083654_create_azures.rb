class CreateAzures < ActiveRecord::Migration[7.0]
  def change
    create_table :azures, id: :uuid do |t|
      t.string :access_key, null: false
      t.string :subdomain, null: false
      t.boolean :enable_check_auth, null: false, default: true
      t.operator_stamps

      t.timestamps
      t.datetime :deleted_at
    end
  end
end
