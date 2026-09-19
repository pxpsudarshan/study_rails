class VocabMycardsController < ApplicationController
  def index
    vocab_code = params[:vocab_code]
    @vocab_code = vocab_code
    @cards = []
    @message = ""
    if vocab_code.present?
      @cards = vocab_cards(vocab_code)
    elsif params[:selected_item].present?
      @cards = current_user.vocab_mycards
                .joins(:vocab_table)
                .where(created_at: period_range(params[:selected_item]))
                .order(created_at: :desc)
    else
      @cards = current_user.vocab_mycards.joins(:vocab_table).order(created_at: :desc)
    end

    if !@cards.present?
      @message = "NO DATA"
    end
  end

  def page_mylang
    @vocab = VocabTable.find(params[:vocab_id])
  end
# below not used
  def create
    @mycard = current_user.vocab_mycards.new(mycard_params)
    @mycard.mycard_check = 1
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

  def toggle
    mycard = current_user.vocab_mycards.find_by(vocab_table_id: params[:card_id])

    if mycard.present?
      mycard.destroy!
    else
      current_user.vocab_mycards.create!(vocab_table_id: params[:card_id] )
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

  # 期間指定用
  def period_range(period)
    case period
    when '1' then 1.day.ago..Time.current
    when '2' then 1.month.ago..Time.current
    when '3' then 3.months.ago..Time.current
    else 1.years.ago..Time.current
    end
  end
end
