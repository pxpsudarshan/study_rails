class CreateBlockIps < ActiveRecord::Migration[7.0]
  def change
    create_table :block_ips, id: :uuid do |t|
      t.string :ipaddr
      t.operator_stamps

      t.timestamps
      t.datetime :deleted_at
    end
  end
end
