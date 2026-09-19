class AddBillingAddressToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :billing_address, :json
  end
end
