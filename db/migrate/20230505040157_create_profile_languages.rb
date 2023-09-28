class CreateProfileLanguages < ActiveRecord::Migration[7.0]
  def change
    create_table :profile_languages, id: :uuid do |t|
      t.references :profile, null: false, foreign_key: true, type: :uuid
      t.integer :native_lang
      t.integer :jp_level
      t.integer :use_lang
      t.integer :use_lang_level
      t.operator_stamps

      t.timestamps
      t.datetime :deleted_at
    end
  end
end
