class Admin::AudioCsController < ApplicationController
  before_action :parent

  def index
    @audio_lang = params[:audio_lang] || 'EN'
    @audio_cs = @audio_b.audio_cs.order(:title_sort)
  end

  def new
    @audio_lang = params[:audio_lang]
    @audio_c = @audio_b.audio_cs.new
  end

  def create
    @audio_lang = params[:audio_lang]
    @audio_c = @audio_b.audio_cs.new(audio_c_params)
    begin
      if @audio_c.save
        redirect_to admin_audio_b_audio_cs_path(audio_lang: @audio_lang), flash: {success: 'Created'}
      else
        render 'new'
      end
    rescue => e
      redirect_to admin_audio_b_audio_cs_path(audio_lang: @audio_lang), flash: {alert: e.message}
    end
  end

  def edit
    @audio_lang = params[:audio_lang]
    @audio_c = @audio_b.audio_cs.find(params[:id])
  end

  def update
    @audio_lang = params[:audio_lang]
    @audio_c = @audio_b.audio_cs.find(params[:id])
    @audio_c.assign_attributes(audio_c_params)
    begin
      if @audio_c.save
        redirect_to admin_audio_b_audio_cs_path(audio_lang: @audio_lang), flash: {success: 'Updated'}
      else
        render 'edit'
      end
    rescue => e
      redirect_to admin_audio_b_audio_cs_path(audio_lang: @audio_lang), flash: {alert: e.message}
    end
  end

  def destroy
    @audio_lang = params[:audio_lang]
    @audio_c = @audio_b.audio_cs.find(params[:id])
    begin
      ActiveRecord::Base.transaction() do
        @audio_c.destroy!
        redirect_to admin_audio_b_audio_cs_path(audio_lang: @audio_lang), flash: {success: 'Deleted'}
      end
    rescue => e
      logger.error(e.message)
      redirect_to admin_audio_b_audio_cs_path(audio_lang: @audio_lang), flash: {alert: e.message}
    end
  end
  
  private

  def parent
    @audio_b = AudioB.find(params[:audio_b_id])
    @audio_a = @audio_b.audio_a
  end

  def audio_c_params
    params.require(:audio_c).permit(
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
