class MenusController < ApplicationController
  before_action :set_lang, except: []
  
  def index
    progress = ChartService.new(current_user).summary_chart.to_h
    @card_learned = progress.fetch("Learned")
    @card_studying = progress.fetch("Studying")
    @card_total = @card_learned + @card_studying
    @learned_percent = @card_total.zero? ? 0 : (@card_learned * 100.0 / @card_total).round
    @genres = VocabGenre.where(vocab_genre_id: nil, hide_flg: false).order(:sort, :sort)
  end

  private
  def set_lang
    @lang = current_user.lang_id
  end
end
