class Admin::AudioDsController < ApplicationController
  before_action :parent

  def index
    @audio_lang = params[:audio_lang] || 'EN'
    @audio_ds = @audio_c_content.audio_ds.order(:sort)
  end

  def show
    @audio_lang = params[:audio_lang]
    @audio_d = @audio_c_content.audio_ds.find(params[:id])
  end

  def new
    @audio_lang = params[:audio_lang]
    @audio_d = @audio_c_content.audio_ds.new
  end

  def create
    @audio_lang = params[:audio_lang]
    @audio_d = @audio_c_content.audio_ds.new(audio_d_params)
    begin
      if @audio_d.save
        redirect_to admin_audio_c_content_audio_ds_path(audio_lang: @audio_lang), flash: {success: 'Created'}
      else
        render 'new'
      end
    rescue => e
      redirect_to admin_audio_c_content_audio_ds_path(audio_lang: @audio_lang), flash: {alert: e.message}
    end
  end

  def edit
    @audio_lang = params[:audio_lang]
    @audio_d = @audio_c_content.audio_ds.find(params[:id])
  end

  def update
    @audio_lang = params[:audio_lang]
    @audio_d = @audio_c_content.audio_ds.find(params[:id])
    @audio_d.assign_attributes(audio_d_params)
    begin
      if @audio_d.save
        redirect_to admin_audio_c_content_audio_ds_path(audio_lang: @audio_lang), flash: {success: 'Updated'}
      else
        render 'edit'
      end
    rescue => e
      redirect_to admin_audio_c_content_audio_ds_path(audio_lang: @audio_lang), flash: {alert: e.message}
    end
  end

    def destroy
    @audio_lang = params[:audio_lang]
    @audio_d = @audio_c_content.audio_ds.find(params[:id])
    begin
      ActiveRecord::Base.transaction() do
        @audio_d.destroy!
        redirect_to admin_audio_c_content_audio_ds_path(audio_lang: @audio_lang), flash: {success: 'Deleted'}
      end
    rescue => e
      logger.error(e.message)
      redirect_to admin_audio_c_content_audio_ds_path(audio_lang: @audio_lang), flash: {alert: e.message}
    end
  end

  private

  def parent
    @audio_c_content = AudioCContent.find(params[:audio_c_content_id])
    @audio_c = @audio_c_content.audio_c
  end

  def audio_d_params
    params.require(:audio_d).permit(
      :content,
      :sort,
      :mpg,
      :customer_flg,
      :voice_gender_flg,
      :update_flg,
      languages_attributes: [
        :id,
        :mpg,
        :content,
        :language,
        :sort,
        :update_flg,
        :male_flg,
        :_destroy
      ]
    )
  end
end
