class Admin::TokuteisController < ApplicationController
  def index
    @audio_lang = params[:audio_lang] || 'EN'
    @tokuteis = Tokutei.where(tokutei_id: nil).order(:sort)
  end

  def show
    @tokutei = Tokutei.find(params[:id])
  end

  def new
    @audio_lang = params[:audio_lang]
    id = params[:id]
    if id.present?
#      @tokutei = Tokutei.find(id).contents.new
      @tokutei = Tokutei.new(tokutei_id: id)
    else
      @tokutei = Tokutei.new
    end
  end

  def create
    @audio_lang = params[:audio_lang]
    @tokutei = Tokutei.new(tokutei_params)
    begin
      if @tokutei.save
        redirect_to admin_tokuteis_path(audio_lang: @audio_lang), flash: {success: 'Created'}
      else
        render 'new'
      end
    rescue => e
      redirect_to admin_tokuteis_path(audio_lang: @audio_lang), flash: {alert: e.message}
    end
  end

  def edit
    @audio_lang = params[:audio_lang]
    @tokutei = Tokutei.find(params[:id])
  end

  def update
    @audio_lang = params[:audio_lang]
    @tokutei = Tokutei.find(params[:id])
    @tokutei.assign_attributes(tokutei_params)
    begin
      if @tokutei.save
        if @tokutei.tokutei_id.present?
          redirect_to edit_admin_tokutei_path(audio_lang: @audio_lang), flash: {success: 'Updated'}
        else
          redirect_to admin_tokuteis_path(audio_lang: @audio_lang), flash: {success: 'Updated'}
        end
      else
        render 'edit'
      end
    rescue => e
      redirect_to admin_tokuteis_path(audio_lang: @audio_lang), flash: {alert: e.message}
    end
  end

  def destroy
    @audio_lang = params[:audio_lang]
    @tokutei = Tokutei.find(params[:id])
    begin
      ActiveRecord::Base.transaction() do
        @tokutei.destroy!
        redirect_to admin_tokuteis_path(audio_lang: @audio_lang), flash: {success: 'Deleted'}
      end
    rescue => e
      logger.error(e.message)
      redirect_to admin_tokuteis_path(audio_lang: @audio_lang), flash: {alert: e.message}
    end
  end

  private

  def tokutei_params
    params.require(:tokutei).permit(
      :title,
      :sort,
      :tokutei_id,
      tokutei_questions_attributes: [
        :id,
        :content,
        :title,
        :sort,
        :image_flg,
        :image,
        :audio_flg,
        :_destroy
      ],
      languages_attributes: [
        :id,
        :content,
        :language,
        :sort,
        :skip_flg,
        :_destroy
      ]
    )
  end
end
