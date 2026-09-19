class AddTokenToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :token, :string
    add_column :users, :email_verify_flg, :boolean, null: false, default: false
    User.update_all(email_verify_flg: true)
  end
end
