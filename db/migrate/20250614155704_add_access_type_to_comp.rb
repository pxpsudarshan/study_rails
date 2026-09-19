class AddAccessTypeToComp < ActiveRecord::Migration[7.0]
  def change
    add_column :comps, :access_type, :integer, null: false, default: 0
    add_column :comps, :login_flg, :boolean, null: false, default: false
  end
end
