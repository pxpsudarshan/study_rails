class AddAccessTypeToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :access_type, :integer, null: false, default: 0
    add_column :users, :login_flg, :boolean, null: false, default: false
  end
end
