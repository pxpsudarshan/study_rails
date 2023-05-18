class AddJpLevelToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :jp_level, :string
  end
end
