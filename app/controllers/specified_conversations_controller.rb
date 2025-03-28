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
      @audio_c = audio_b.audio_cs.order(:title_sort)
    end
  end
  
  def get_case_name
    @case_names = []
    if params[:id].present?
      @case_names = AudioC.find(params[:id]).audio_c_contents.order(:sort)
    end
    respond_to do |format|
      format.json { render json: @case_names }
    end
  end

  def audio_d
    @audio_d = []
    @selected_language = params[:title_nation][:language]
    if params[:title_nation][:content_id].present?
      audio_c_content = AudioCContent.find(params[:title_nation][:content_id])
      @audio_d = audio_c_content.audio_ds.order(:sort)
    end
  end

  def set_lang
    @lang = current_user.lang_id
  end
end
