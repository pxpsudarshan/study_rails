class AddEntryNoToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :entry_no, :integer, null: false, default: 0
  end
end
