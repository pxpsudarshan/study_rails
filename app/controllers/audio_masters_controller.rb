class AudioMastersController < ApplicationController
    def index
        puts "hello"
        @count = 0
        @audio_a = []
        @audio_a = AudioA.order(:sort)
        if params[:check_id].present?
            @count = 1
        end
    end
end
