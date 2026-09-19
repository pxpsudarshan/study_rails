class AddChannelToComp < ActiveRecord::Migration[7.0]
  def change
    add_reference :comps, :channel, null: true, foreign_key: true, type: :uuid
  end
end
