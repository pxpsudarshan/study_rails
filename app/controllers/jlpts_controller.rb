class JlptsController < ApplicationController
  def index
    jlpt = params[:jlpt].to_i
    @cards = []
    @message = ""
    # @cards = VocabStore.where(jlpt_class: jlpt).order(:vocab_org)
    @cards = VocabStore.left_outer_joins(:vocab_mycards)
                        .where(jlpt_class: jlpt)
                        .select('vocab_stores.vocab_read,
                                 vocab_stores.vocab_code,
                                 vocab_stores.nation_vocab,
                                 vocab_mycards.vocab_org AS mycard')
                        .order(:vocab_org)
    if !@cards.present?
      @message = "NO DATA"
    end
  end

  def page_mylang
    vocab_code = params[:vocab_code]
    @vocab_stores = VocabStore.where(vocab_code: vocab_code).order(:vocab_org)
  end

  def create
    @mycard = current_user.vocab_mycards.new(mycard_params)
    if @mycard.save
      redirect_to jlpts_path(vocab_code: @mycard.vocab_code), flash: {success: 'created'}
    else
      redirect_to gois_path(goi: {goi: mycard_params[:vocab_read]}), flash: {alert: 'error'}
    end
  end

  def update
    @mycard = VocabMycard.find(params[:id])
    if @mycard.save
      redirect_to jlpts_path(vocab_code: @mycard.vocab_code), flash: {success: 'updated'}
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
