class CreateAudioCContents < ActiveRecord::Migration[7.0]
  def change
    create_table :audio_c_contents, id: :uuid do |t|
      t.references :audio_c, null: false, foreign_key: true, type: :uuid
      t.text :content
      t.integer :sort, null: false, default: 0
      t.operator_stamps

      t.timestamps
      t.datetime :deleted_at
    end
  end
end
