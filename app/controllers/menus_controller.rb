class MenusController < ApplicationController
  before_action :set_lang, except: []
  
  def index
#   @tokutei_bs = TokuteiB.where(tokutei_a_id: nil).order(:sort)
 
    
  end

  private
  def set_lang
    @lang = current_user.lang_id
  end
end
