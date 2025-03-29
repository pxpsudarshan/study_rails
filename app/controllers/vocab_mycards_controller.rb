class VocabMycardsController < ApplicationController
  def index
    vocab_code = params[:vocab_code]
    @vocab_code = vocab_code
    @cards = []
    @message = ""
    if vocab_code.present?
        #関連する語彙
        vocab_code_kanji = vocab_code.scan(/\p{Han}/).join
        @cards = []
        if vocab_code_kanji.present?
          @cards = VocabTable
            .joins(:vocab_mycards)
            .where(vocab_mycards: { user_id: current_user.id })
            .where('vocab_tables.vocab_code ~* ?', "[#{vocab_code_kanji}]")
            .where.not(vocab_code: vocab_code)
        end
    elsif params[:selected_item].present?
      day = params[:selected_item].to_i
      top_date = Date.today
      case day
      when 1
        prev_date = top_date - 1.day
      when 2
        prev_date = top_date - 7.day
      when 3
        prev_date = top_date - 1.month
      else
        prev_date = top_date - 1.year
      end
      @cards = current_user.vocab_mycards
                .joins(:vocab_table)
                .where("DATE(vocab_mycards.created_at) BETWEEN ? AND ?", prev_date, top_date)
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
