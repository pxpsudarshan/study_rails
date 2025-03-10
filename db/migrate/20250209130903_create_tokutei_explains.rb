class CreateTokuteiExplains < ActiveRecord::Migration[7.0]
  def change
    create_table :tokutei_explains, id: :uuid do |t|
      t.references :explains, polymorphic: true, null: false, type: :uuid
      t.text :content
      t.boolean :image_flg, null: false, default: false
      t.boolean :audio_flg, null: false, default: false
      t.operator_stamps

      t.timestamps
      t.datetime :deleted_at
    end
  end
end
