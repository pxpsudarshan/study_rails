class SpecifiedConversationsController < ApplicationController
  before_action :set_lang, except: []
  def index
    if params[:id].present?
      audio_a = AudioA.find(params[:id])
      @audio_b = audio_a.audio_bs.order(:sort)
    end
  end

  def audio_c
    if params[:id].present?
      audio_b = AudioB.find(params[:id])
      @audio_c = audio_b.audio_cs.order(:title_sort, :case_name_sort)
    end
  end
  
  def get_case_name
    @case_names = []
    if params[:sort].present?
      audio_b = AudioB.find(params[:audio_b_id])
      @case_names = audio_b.audio_cs.where(title_sort: params[:sort]).order(:case_name_sort)
    end
    respond_to do |format|
      format.json { render json: @case_names }
    end
  end

  def audio_d
    @audio_d = []
    @selected_language = params[:title_nation][:language]
    if params[:title_nation][:case_name_nation].present?
      audio_c = AudioC.find(params[:title_nation][:case_name_nation])
      @audio_d = audio_c.audio_ds.where(lang: @selected_language).order(:sort)
    end
  end

  protect_from_forgery except: :speech_audio  # Disable CSRF protection for the action if needed

  def speech_audio
    puts "responce12"
    audio_file = params[:audio]


    if audio_file
      file_path = Rails.root.join('tmp', 'recording.webm')
      
      # Save the uploaded audio file to disk
      File.open(file_path, 'wb') do |file|
        file.write(audio_file.read)
      end
      puts "responce2"

      # Call the Python script to transcribe the audio
      text = `python3 speech_to_text.py #{file_path}`.strip

      # Send the transcription back as JSON response
      render json: { transcription: text }, status: :ok
    else
      render json: { error: 'No audio file provided' }, status: :unprocessable_entity
    end
  end

  # def speech_audio
  #   script_path = Rails.root.join('lib', 'speech_to_text.py')
  #   @transcription = `python3 #{script_path}`.strip
  #   puts "what the hell #{script_path}"
  #   puts "what the hell #{@transcription.blank?}"

  #   if @transcription.blank?
  #     flash[:alert] = "Failed to capture speech. Please try again."
  #     # render :audio_c
  #   else
  #     puts "what the hell #{@transcription}"
  #     flash[:notice] = "Speech recognized successfully!"
  #     # render :audio_c
  #   end
  # end

  # def speech_audio

  #   puts "responce1"
  #   audio_file = params[:audio]

  #   if audio_file
  #     # Save the audio file temporarily in the `tmp` directory
  #     file_path = Rails.root.join('tmp', 'recording.webm')
  #     File.open(file_path, 'wb') do |file|
  #       file.write(audio_file.read)
  #     end
  #     # puts "responce2"
  #     # Convert the audio to a format compatible with the speech-to-text service (e.g., FLAC or WAV)
  #     # converted_file_path = convert_to_flac(file_path)

  #     puts "responce3"

  #     # Use a speech-to-text service to transcribe the audio
  #     #text = transcribe_audio(converted_file_path)
  #     # text = `python3 #{converted_file_path}`.strip
  #     text = `python3 speech_to_text.py #{file_path}`.strip
  #     puts "responce4 #{text}"

  #     render json: { transcription: text }, status: :ok
  #   else
  #     render json: { error: 'No audio file provided' }, status: :unprocessable_entity
  #   end
  # end

  # private

  # def convert_to_flac(file_path)
  #   # Use FFMPEG to convert to FLAC or another supported format
  #   flac_path = file_path.to_s.gsub('.webm', '.flac')
  #   system("ffmpeg -i #{file_path} -c:a flac #{flac_path}")
  #   flac_path
  # end

  # def transcribe_audio(file_path)
  #   require "google/cloud/speech"

  #   speech = Google::Cloud::Speech.speech
  #   audio  = { uri: file_path.to_s }
  #   config = { encoding: :FLAC, sample_rate_hertz: 16000, language_code: "en-US" }

  #   response = speech.recognize config: config, audio: audio
  #   response.results.map(&:alternatives).flatten.map(&:transcript).join(" ")
  # end

  def set_lang
    @lang = current_user.lang_id
  end
end
