class JlptsController < ApplicationController
  def index
    @cards = VocabTable.where(jlpt_level: params[:jlpt])
                        .page(params[:page]).per(params[:per])
  end

  def show
    vocab = VocabTable.find(params[:id])
    vocab_code = vocab.vocab_code
    jlpt_level = vocab.jlpt_level
    @gois = {
      vocab_read: vocab.vocab_read,
      vocab_code: vocab_code,
      jlpt_level: 'N'+jlpt_level.to_s,
      vocab_kanji: vocab.kanji_tables,
      eng_mean: vocab.vocab_nations.where(lang: 'EN').first&.nation_code,
      nation_mean: vocab.vocab_nations.where(lang: current_user.lang_id).first&.nation_code,
    }
    @count = 1
    @mycard = current_user.vocab_mycards.where(vocab_table_id: vocab.id).first
    @vocab_mycard = @mycard.present? ? '⭐️' : '☆'
    current_user.vocab_mycards.create!(vocab_table_id: vocab.id) if @mycard.blank?
  end

  private

end
