class Admin::AudioBsController < ApplicationController
  before_action :parent

  def index
    @audio_lang = params[:audio_lang] || 'EN'
    @audio_bs = @audio_a.audio_bs.order(:sort)
  end

  def new
    @audio_lang = params[:audio_lang]
    @audio_b = @audio_a.audio_bs.new
  end

  def create
    @audio_lang = params[:audio_lang]
    @audio_b = @audio_a.audio_bs.new(audio_b_params)
    begin
      if @audio_b.save
        redirect_to admin_audio_a_audio_bs_path(audio_lang: @audio_lang), flash: {success: 'Created'}
      else
        render 'new'
      end
    rescue => e
      redirect_to admin_audio_a_audio_bs_path(audio_lang: @audio_lang), flash: {alert: e.message}
    end
  end

  def edit
    @audio_lang = params[:audio_lang]
    @audio_b = @audio_a.audio_bs.find(params[:id])
  end

  def update
    @audio_lang = params[:audio_lang]
    @audio_b = @audio_a.audio_bs.find(params[:id])
    @audio_b.assign_attributes(audio_b_params)
    begin
      if @audio_b.save
        redirect_to admin_audio_a_audio_bs_path(audio_lang: @audio_lang), flash: {success: 'Updated'}
      else
        render 'edit'
      end
    rescue => e
      redirect_to admin_audio_a_audio_bs_path(audio_lang: @audio_lang), flash: {alert: e.message}
    end
  end

  def destroy
    @audio_lang = params[:audio_lang]
    @audio_b = @audio_a.audio_bs.find(params[:id])
    begin
      ActiveRecord::Base.transaction() do
        @audio_b.destroy!
        redirect_to admin_audio_a_audio_bs_path(audio_lang: @audio_lang), flash: {success: 'Deleted'}
      end
    rescue => e
      logger.error(e.message)
      redirect_to admin_audio_a_audio_bs_path(audio_lang: @audio_lang), flash: {alert: e.message}
    end
  end

  private

  def parent
    @audio_a = AudioA.find(params[:audio_a_id])
  end

  def audio_b_params
    params.require(:audio_b).permit(
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
