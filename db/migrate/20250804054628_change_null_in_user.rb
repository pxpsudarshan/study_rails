class ChangeNullInUser < ActiveRecord::Migration[7.0]
  def change
    change_column_null :users, :sei, false
    change_column_null :users, :mei, false
    change_column_null :users, :sei_kana, false
    change_column_null :users, :mei_kana, false
    change_column_null :users, :mobile, false
  end
end
