class RemoveBusinessTypeFromUser < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :business_type, :string
    remove_column :users, :company_flg, :boolean, null: false, default: false
    remove_column :users, :company_name, :string
    remove_column :users, :company_type, :string
    remove_column :users, :company_url, :string
    remove_column :users, :department, :string
    remove_column :users, :company_code, :string
  end
end
