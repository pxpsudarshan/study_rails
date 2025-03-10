class Admin::AudioCContentsController < ApplicationController
  before_action :parent

  def index
    @audio_lang = params[:audio_lang] || 'EN'
    @audio_c_contents = @audio_c.audio_c_contents.order(:sort)
  end

  def new
    @audio_lang = params[:audio_lang]
    @audio_c_content = @audio_c.audio_c_contents.new
  end

  def create
    @audio_lang = params[:audio_lang]
    @audio_c_content = @audio_c.audio_c_contents.new(audio_c_content_params)
    begin
      if @audio_c_content.save
        redirect_to admin_audio_c_audio_c_contents_path(audio_lang: @audio_lang), flash: {success: 'Created'}
      else
        render 'new'
      end
    rescue => e
      redirect_to admin_audio_c_audio_c_contents_path(audio_lang: @audio_lang), flash: {alert: e.message}
    end
  end

  def edit
    @audio_lang = params[:audio_lang]
    @audio_c_content = @audio_c.audio_c_contents.find(params[:id])
  end

  def update
    @audio_lang = params[:audio_lang]
    @audio_c_content = @audio_c.audio_c_contents.find(params[:id])
    @audio_c_content.assign_attributes(audio_c_content_params)
    begin
      if @audio_c_content.save
        redirect_to admin_audio_c_audio_c_contents_path(audio_lang: @audio_lang), flash: {success: 'Updated'}
      else
        render 'edit'
      end
    rescue => e
      redirect_to admin_audio_c_audio_c_contents_path(audio_lang: @audio_lang), flash: {alert: e.message}
    end
  end

  def destroy
    @audio_lang = params[:audio_lang]
    @audio_c_content = @audio_c.audio_c_contents.find(params[:id])
    begin
      ActiveRecord::Base.transaction() do
        @audio_c_content.destroy!
        redirect_to admin_audio_c_audio_c_contents_path(audio_lang: @audio_lang), flash: {success: 'Deleted'}
      end
    rescue => e
      logger.error(e.message)
      redirect_to admin_audio_c_audio_c_contents_path(audio_lang: @audio_lang), flash: {alert: e.message}
    end
  end
  
  private

  def parent
    @audio_c = AudioC.find(params[:audio_c_id])
    @audio_b = @audio_c.audio_b
  end

  def audio_c_content_params
    params.require(:audio_c_content).permit(
      :content,
      :sort,
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
