class CreateChannels < ActiveRecord::Migration[7.0]
  def change
    create_table :channels, id: :uuid do |t|
      t.string :channel_name
      t.operator_stamps

      t.timestamps
      t.datetime :deleted_at
    end
  end
end
