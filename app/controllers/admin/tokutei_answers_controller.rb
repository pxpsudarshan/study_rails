class Admin::TokuteiAnswersController < ApplicationController
  def show
    @tokutei_answer = TokuteiAnswer.find(params[:id])
  end

  def new
    @audio_lang = params[:audio_lang]
    @tokutei_answer = TokuteiAnswer.new
  end

  def create
    @audio_lang = params[:audio_lang]
    @tokutei_answer = TokuteiAnswer.new(tokutei_params)
    begin
      if @tokutei_answer.save
        redirect_to admin_tokutei_answers_path(audio_lang: @audio_lang), flash: {success: 'Created'}
      else
        render 'new'
      end
    rescue => e
      redirect_to admin_tokutei_answers_path(audio_lang: @audio_lang), flash: {alert: e.message}
    end
  end

  def edit
    @audio_lang = params[:audio_lang]
    @tokutei_answer = TokuteiAnswer.find(params[:id])
    @tokutei_answer.build_tokutei_explain if @tokutei_answer.tokutei_explain.blank?
  end

  def update
    @audio_lang = params[:audio_lang]
    @tokutei_answer = TokuteiAnswer.find(params[:id])
    @tokutei_answer.assign_attributes(tokutei_answer_params)
    begin
      if @tokutei_answer.save
        redirect_to edit_admin_tokutei_answer_path(audio_lang: @audio_lang), flash: {success: 'Updated'}
      else
        render 'edit'
      end
    rescue => e
      redirect_to edit_admin_tokutei_answer_path(audio_lang: @audio_lang), flash: {alert: e.message}
    end
  end

  def destroy
    @audio_lang = params[:audio_lang]
    @tokutei_answer = TokuteiAnswer.find(params[:id])
    begin
      ActiveRecord::Base.transaction() do
        @tokutei_answer.destroy!
        redirect_to admin_tokutei_answers_path(audio_lang: @audio_lang), flash: {success: 'Deleted'}
      end
    rescue => e
      logger.error(e.message)
      redirect_to admin_tokutei_answers_path(audio_lang: @audio_lang), flash: {alert: e.message}
    end
  end

  private

  def tokutei_answer_params
    params.require(:tokutei_answer).permit(
      :sort,
      :title,
      :content,
      :image_flg,
      :image,
      :audio_flg,
      :correct_flg,
      tokutei_explain_attributes: [
        :id,
        :content,
        :image_flg,
        :image,
        :audio_flg,
        :_destroy,
        languages_attributes: [
          :id,
          :content,
          :language,
          :sort,
          :skip_flg,
          :_destroy
        ],
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
