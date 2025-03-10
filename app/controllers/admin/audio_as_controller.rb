class Admin::AudioAsController < ApplicationController
  def index
    @audio_lang = params[:audio_lang] || 'EN'
    @audio_as = AudioA.order(:sort)
  end

  def show
    @audio_a = AudioA.find(params[:id])
  end

  def new
    @audio_lang = params[:audio_lang]
    @audio_a = AudioA.new
  end

  def create
    @audio_lang = params[:audio_lang]
    @audio_a = AudioA.new(audio_a_params)
    begin
      if @audio_a.save
        redirect_to admin_audio_as_path(audio_lang: @audio_lang), flash: {success: 'Created'}
      else
        render 'new'
      end
    rescue => e
      redirect_to admin_audio_as_path(audio_lang: @audio_lang), flash: {alert: e.message}
    end
  end

  def edit
    @audio_lang = params[:audio_lang]
    @audio_a = AudioA.find(params[:id])
  end

  def update
    @audio_lang = params[:audio_lang]
    @audio_a = AudioA.find(params[:id])
    @audio_a.assign_attributes(audio_a_params)
    begin
      if @audio_a.save
        redirect_to admin_audio_as_path(audio_lang: @audio_lang), flash: {success: 'Updated'}
      else
        render 'edit'
      end
    rescue => e
      redirect_to admin_audio_as_path(audio_lang: @audio_lang), flash: {alert: e.message}
    end
  end

  def destroy
    @audio_lang = params[:audio_lang]
    @audio_a = AudioA.find(params[:id])
    begin
      ActiveRecord::Base.transaction() do
        @audio_a.destroy!
        redirect_to admin_audio_as_path(audio_lang: @audio_lang), flash: {success: 'Deleted'}
      end
    rescue => e
      logger.error(e.message)
      redirect_to admin_audio_as_path(audio_lang: @audio_lang), flash: {alert: e.message}
    end
  end

  private

  def audio_a_params
    params.require(:audio_a).permit(
      :title_nation,
      languages_attributes: [
        :id,
        :content,
        :language,
        :sort,
        :_destroy
      ]
    )
  end
end
