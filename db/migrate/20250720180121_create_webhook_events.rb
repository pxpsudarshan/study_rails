class CreateWebhookEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :webhook_events, id: :uuid do |t|
      t.string :source
      t.json :data
      t.integer :state, default: 0, null: false
      t.string :external_id
      t.string :processing_errors
      t.operator_stamps

      t.timestamps
      t.datetime :deleted_at
    end
  end
end
