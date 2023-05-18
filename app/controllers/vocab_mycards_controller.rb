class VocabMycardsController < ApplicationController
  def index
    day = params[:day].to_i
    @mode = params[:mode].present? ? params[:mode].to_i : -1
    vocab_code = params[:vocab_code]
    @cards = []
    if vocab_code.present?
      @cards = current_user.vocab_mycards.where(vocab_code: vocab_code).order(created_at: :desc)
    else
      card = current_user.vocab_mycards.order(created_at: :desc).first
      if card.present?
        top_date = card.created_at.to_date
        case day
        when 1
          prev_date = top_date - 1.day
        when 7
          prev_date = top_date - 7.day
        else
          prev_date = top_date - 1.month
        end
        @cards = current_user.vocab_mycards.where("DATE(created_at) BETWEEN ? AND ?", prev_date, top_date).order(created_at: :desc)
      end
    end if current_user.mycard_sign
  end

  def page_mylang
    vocab_code = params[:vocab_code]
    @vocab_stores = VocabStore.where(vocab_code: vocab_code).order(:vocab_org)
  end

  def create
    @mycard = current_user.vocab_mycards.new(mycard_params)
    if @mycard.save
      redirect_to vocab_mycards_path(vocab_code: @mycard.vocab_code), flash: {success: 'created'}
    else
      redirect_to gois_path(goi: {goi: mycard_params[:vocab_read]}), flash: {alert: 'error'}
    end
  end

  def update
    @mycard = VocabMycard.find(params[:id])
    if @mycard.save
      redirect_to vocab_mycards_path(vocab_code: @mycard.vocab_code), flash: {success: 'updated'}
    else
      redirect_to gois_path(goi: {goi: mycard_params[:vocab_read]}), flash: {alert: 'error'}
    end
  end

  private

  def mycard_params
    params.require(:vocab_mycard).permit(
      :vocab_read,
      :vocab_code,
      :vocab_org,
      :vocab_code,
      :vocab_read,
      :kanji_body,
      :jlpt_class,
      :jlpt_level,
      :parts_body,
      :recent_date,
      :mycard_check,
    )
  end
end
