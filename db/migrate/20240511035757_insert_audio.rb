class InsertAudio < ActiveRecord::Migration[7.0]
  def up
    AudioD.all.each do |a|
      a.mpg.attach(io: File.open(Rails.root.join('tmp','storage', 'audio', "#{a.id}_#{a.lang}.mp3")), filename: "audio_#{a.lang}.mp3")
    end
  end
end
