class MenusController < ApplicationController
  before_action :set_lang

  def index
    cards = current_user.vocab_mycards
    @total_cards = cards.count
    @learned_cards = cards.where(mycard_level: 1).count
    @learning_cards = @total_cards - @learned_cards
    @learned_percent = @total_cards.zero? ? 0 : (@learned_cards * 100.0 / @total_cards).round
    @today_cards = cards.where(created_at: Time.current.beginning_of_day..Time.current).count
    @recent_cards = cards.joins(:vocab_table).where(vocab_tables: { hide_flg: false })
                         .includes(:vocab_table).order(updated_at: :desc).limit(3)
    @recent_genres = RecentStudyGenres.new(current_user, @recent_cards).call
    @topics = Tokutei.where(tokutei_id: nil)
    @conversations = AudioA.order(:sort)
  end

  private

  def set_lang
    @lang = current_user.lang_id
  end
end
