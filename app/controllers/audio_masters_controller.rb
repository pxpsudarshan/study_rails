class AudioMastersController < ApplicationController
    def index
        puts "hello"
        @count = 0
        @active_tab = params[:active_tab] || 'tab-1'
        @audio_a = AudioA.order(:sort)
        @selected_audio_a=params[:audio_a]
        @audio_b = AudioB.where(audio_a_id: @selected_audio_a) if @selected_audio_a.present?
        @selected_audio_b=params[:audio_b]
        @audio_c = AudioC.where(audio_b_id: @selected_audio_b) if @selected_audio_b.present?
        @selected_audio_c=params[:audio_c]
        @audio_d = AudioD.order(:sort)
        if params[:check_id].present?
            @count = 1
        end
    end
end