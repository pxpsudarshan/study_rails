class AddUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :sei, :string
    add_column :users, :mei, :string
    add_column :users, :sei_kana, :string
    add_column :users, :mei_kana, :string
    add_column :users, :mobile, :string
  end
end
