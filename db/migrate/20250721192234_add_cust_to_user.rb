class AddCustToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :stripe_customer_id, :string
    add_index :users, :stripe_customer_id, unique: true
    add_column :users, :subscription_status, :string, default: 'incomplete', null: false
  end
end
