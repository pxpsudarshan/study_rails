class AddCompanyToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :business_type, :string
    add_column :users, :company_flg, :boolean, null: false, default: false
    add_column :users, :company_name, :string
    add_column :users, :company_type, :string
    add_column :users, :company_url, :string
    add_column :users, :department, :string
    add_column :users, :company_code, :string
  end
end
