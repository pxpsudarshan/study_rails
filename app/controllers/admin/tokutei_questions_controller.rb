class Admin::TokuteiQuestionsController < ApplicationController
  def show
    @tokutei_question = TokuteiQuestion.find(params[:id])
  end

  def new
    @audio_lang = params[:audio_lang]
    @tokutei_question = TokuteiQuestion.new
  end

  def create
    @audio_lang = params[:audio_lang]
    @tokutei_question = TokuteiQuestion.new(tokutei_params)
    begin
      if @tokutei_question.save
        redirect_to admin_tokutei_questions_path(audio_lang: @audio_lang), flash: {success: 'Created'}
      else
        render 'new'
      end
    rescue => e
      redirect_to admin_tokutei_questions_path(audio_lang: @audio_lang), flash: {alert: e.message}
    end
  end

  def edit
    @audio_lang = params[:audio_lang]
    @tokutei_question = TokuteiQuestion.find(params[:id])
    @tokutei_question.build_tokutei_explain if @tokutei_question.tokutei_explain.blank?
  end

  def update
    @audio_lang = params[:audio_lang]
    @tokutei_question = TokuteiQuestion.find(params[:id])
    @tokutei_question.assign_attributes(tokutei_question_params)
    begin
      if @tokutei_question.save
        redirect_to edit_admin_tokutei_question_path(audio_lang: @audio_lang), flash: {success: 'Updated'}
      else
        render 'edit'
      end
    rescue => e
      redirect_to edit_admin_tokutei_question_path(audio_lang: @audio_lang), flash: {alert: e.message}
    end
  end

  def destroy
    @audio_lang = params[:audio_lang]
    @tokutei_question = TokuteiQuestion.find(params[:id])
    begin
      ActiveRecord::Base.transaction() do
        @tokutei_question.destroy!
        redirect_to admin_tokutei_questions_path(audio_lang: @audio_lang), flash: {success: 'Deleted'}
      end
    rescue => e
      logger.error(e.message)
      redirect_to admin_tokutei_questions_path(audio_lang: @audio_lang), flash: {alert: e.message}
    end
  end

  private

  def tokutei_question_params
    params.require(:tokutei_question).permit(
      :sort,
      :title,
      :content,
      :image_flg,
      :image,
      :audio_flg,
      tokutei_explain_attributes: [
        :id,
        :content,
        :image_flg,
        :audio_flg,
        :image,
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
      ],
      tokutei_answers_attributes: [
        :id,
        :title,
        :content,
        :sort,
        :correct_flg,
        :_destroy
      ]
    )
  end
end
