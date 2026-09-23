class OrganizeVideoLearning < ActiveRecord::Migration[7.0]
  def change
    create_table :video_genres, id: :uuid do |t|
      t.references :video_genre, type: :uuid, foreign_key: true
      t.references :channel, type: :uuid, foreign_key: true
      t.string :title, null: false
      t.text :content
      t.integer :sort, null: false, default: 0
      t.boolean :hide_flg, null: false, default: false
      t.uuid :created_by
      t.uuid :updated_by
      t.uuid :deleted_by
      t.datetime :deleted_at
      t.timestamps
    end
    add_reference :video_lessons, :video_genre, type: :uuid, foreign_key: true
    add_reference :video_lessons, :channel, type: :uuid, foreign_key: true
    add_column :video_lessons, :content, :text
    add_column :video_lessons, :sort, :integer, null: false, default: 0
    add_column :video_lessons, :hide_flg, :boolean, null: false, default: true
    add_column :video_lessons, :created_by, :uuid
    add_column :video_lessons, :updated_by, :uuid
    add_column :video_lessons, :deleted_by, :uuid
    add_column :video_lessons, :deleted_at, :datetime
    reversible do |direction|
      direction.up do
        execute <<~SQL
          UPDATE video_lessons SET created_by = user_id, updated_by = user_id,
            channel_id = comps.channel_id
          FROM users LEFT JOIN comps ON comps.id = users.comp_id
          WHERE video_lessons.user_id = users.id
        SQL
      end
    end
  end
end
