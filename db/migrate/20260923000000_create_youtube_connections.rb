class CreateYoutubeConnections < ActiveRecord::Migration[7.0]
  def change
    create_table :youtube_connections, id: :uuid do |t|
      t.references :user, type: :uuid, null: false, foreign_key: true, index: { unique: true }
      t.text :encrypted_tokens, null: false
      t.datetime :expires_at, null: false
      t.timestamps
    end
    add_column :video_lessons, :youtube_caption_id, :string
  end
end
