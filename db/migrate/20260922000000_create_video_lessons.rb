class CreateVideoLessons < ActiveRecord::Migration[7.0]
  def change
    create_table :video_lessons, id: :uuid do |t|
      t.references :user, type: :uuid, null: false, foreign_key: true
      t.string :title, null: false
      t.string :youtube_video_id, null: false
      t.jsonb :subtitle_cues, null: false, default: []
      t.timestamps
    end
  end
end
