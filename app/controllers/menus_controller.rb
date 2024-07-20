class MenusController < ApplicationController
  def index
    @tokutei_as = TokuteiA.order(:sort)
    @audio_as = AudioA.order(:sort)
  end

end
