class CreateTokuteiQuestions < ActiveRecord::Migration[7.0]
  def change
    create_table :tokutei_questions, id: :uuid do |t|
      t.references :tokutei, null: false, foreign_key: true, type: :uuid
      t.string :title, null: false
      t.integer :sort, null: false, default: 0
      t.boolean :image_flg, null: false, default: false
      t.boolean :audio_flg, null: false, default: false
      t.text :content, null: false
      t.operator_stamps

      t.timestamps
      t.datetime :deleted_at
    end
  end
end
