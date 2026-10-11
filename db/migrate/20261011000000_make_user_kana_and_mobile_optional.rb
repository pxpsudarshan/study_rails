class MakeUserKanaAndMobileOptional < ActiveRecord::Migration[7.0]
  def up
    change_column_null :users, :sei_kana, true
    change_column_null :users, :mei_kana, true
    change_column_null :users, :mobile, true
  end

  def down
    change_column_null :users, :sei_kana, false, ""
    change_column_null :users, :mei_kana, false, ""
    change_column_null :users, :mobile, false, ""
  end
end
