class AddAddressCountryToProfile < ActiveRecord::Migration[7.0]
  def change
    add_column :profiles, :address_country, :string
  end
end
