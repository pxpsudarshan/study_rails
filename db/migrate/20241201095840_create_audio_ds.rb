class CreateAudioDs < ActiveRecord::Migration[7.0]
  def change
    create_table :audio_ds, id: :uuid do |t|
      t.references :audio_c_content, null: false, foreign_key: true, type: :uuid
      t.integer :sort, null: false, default: 0
      t.boolean :customer_flg, null: false, default: false
      t.boolean :voice_gender_flg, null: false, default: false
      t.text :content
      t.operator_stamps

      t.timestamps
      t.datetime :deleted_at
    end
  end
end
