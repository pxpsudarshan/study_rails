class ChangeAudio < ActiveRecord::Migration[7.0]
  def up
    execute "alter table audio_as alter column title_nation type varchar;"
    execute "alter table audio_bs alter column title_nation type varchar;"
    execute "alter table audio_cs alter column title_nation type varchar;"
 end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
