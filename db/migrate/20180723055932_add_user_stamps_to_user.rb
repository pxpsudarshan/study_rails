class AddUserStampsToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :deleted_at, :datetime
    add_column :users, :created_by, :uuid
    add_column :users, :updated_by, :uuid
    add_column :users, :deleted_by, :uuid
  end
end
