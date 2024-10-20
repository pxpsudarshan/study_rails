class SpecifiedConversationsController < ApplicationController
  before_action :set_lang, except: []
  def index
    if params[:id].present?
      audio_a = AudioA.find(params[:id])
      @audio_b = audio_a.audio_bs.order(:sort)
    end
  end

  def audio_c
    if params[:id].present?
      audio_b = AudioB.find(params[:id])
      @audio_c = audio_b.audio_cs.order(:title_sort, :case_name_sort)
    end
  end
  
  def get_case_name
    @case_names = []
    if params[:sort].present?
      audio_b = AudioB.find(params[:audio_b_id])
      @case_names = audio_b.audio_cs.where(title_sort: params[:sort]).order(:case_name_sort)
    end
    respond_to do |format|
      format.json { render json: @case_names }
    end
  end

  def audio_d
    @audio_d = []
    @selected_language = params[:title_nation][:language]
    if params[:title_nation][:case_name_nation].present?
      audio_c = AudioC.find(params[:title_nation][:case_name_nation])
      @audio_d = audio_c.audio_ds.where(lang: @selected_language).order(:sort)
    end
  end

  def set_lang
    @lang = current_user.lang_id
  end
end
