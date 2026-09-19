class AddCompToComp < ActiveRecord::Migration[7.0]
  def change
    add_reference :comps, :comp, null: true, foreign_key: true, type: :uuid
    add_column :comps, :user_count, :integer, null: false, default: 9999
  end
end
