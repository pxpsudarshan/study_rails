class GoisController < ApplicationController
  def index
    @count = 0
    if params[:goi][:goi].present?
      goi = params[:goi][:goi]
      vocab_code = ''
      jlpt_level = ''
      gois = VocabTable.where(hide_flg: false).where("vocab_read LIKE ?", "%#{goi}%")
      gois = gois.comp_vocab_tables(current_user.comp.channel_id) if current_user.comp&.channel_id.present?
      gois = gois.comp_vocab_tables(nil) unless current_user.comp&.channel_id.present?
      if gois.present?
        if gois.count > 1
          @gois = []
          gois.each do |vocab|
            vocab_org = vocab.id
            lang_text = ''
            #vocab_store = VocabStore.find_by(vocab_org: vocab_org)
            #lang_text = vocab_store.nation_vocab["VN"].join(",") if vocab_store.present? && vocab_store.nation_vocab.present?
            mycard = current_user.vocab_mycards.where(vocab_table_id: vocab.id).first
            vocab_mycard = mycard.present? ? '⭐️' : ''
            arr = {
              vocab_org: vocab_org,
              vocab_code: vocab.vocab_code,
              vocab_mycard: vocab_mycard,
              lang_vocab: 'N' + (vocab.jlpt_level.to_s),
            }
            @gois << arr
            vocab_code = vocab.vocab_code
          end
#          logger.info(@gois.to_s)
          @count = @gois.count
        end

        if gois.count == 1
          vocab = gois.first
          vocab_code = vocab.vocab_code
          jlpt_level = vocab.jlpt_level
          @gois = {
            vocab_read: vocab.vocab_read,
            vocab_code: vocab_code,
            #unit_sheet: (vocab.jlpt_level),
            jlpt_level: 'N'+jlpt_level.to_s,
            vocab_kanji: vocab.kanji_tables,
            eng_mean: vocab.vocab_nations.where(hide_flg: false, lang: 'EN').first,
            nation_mean: vocab,
          }
          @count = 1
          @mycard = current_user.vocab_mycards.where(vocab_table_id: vocab.id).first if @count != 0
          @vocab_mycard = @mycard.present? ? '⭐️' : '☆'
          @mycard = current_user.vocab_mycards.create!(vocab_table_id: vocab.id) if @mycard.blank?
          @cards = vocab_cards(vocab_code)
        end
      end
    end if params[:goi].present?
  end

  def vocab_double
    if params[:goi][:vocab_org].present?
      vocab_org = params[:goi][:vocab_org]
      vocab = VocabTable.find(vocab_org)
      vocab_code = vocab.vocab_code
      jlpt_level = vocab.jlpt_level
      @gois = {
        vocab_read: vocab.vocab_read,
        vocab_code: vocab_code,
        unit_sheet: 'N' + (vocab.jlpt_level.to_s),
        jlpt_level: 'N' + jlpt_level.to_s,
        vocab_kanji: vocab.kanji_tables,
        eng_mean: vocab.vocab_nations.where(hide_flg: false, lang: 'EN').first,
        nation_mean: vocab,
      }
      @count = 1
      @mycard = current_user.vocab_mycards.where(vocab_table_id: vocab.id).first if vocab.present?
      @vocab_mycard = @mycard.present? ? '⭐️' : '☆'
      @mycard = current_user.vocab_mycards.create!(vocab_table_id: vocab.id) if @mycard.blank?
      @cards = vocab_cards(vocab_code)
    end if params[:goi].present?
  end

  def update
    vt = VocabTable.find(params[:id])
    vt.assign_attributes(goi_params)
    @result = vt.save
  end

  def toggle
    vocab = VocabTable.find(params[:vocab_id])
    vn = vocab.vocab_nations.where(lang: current_user.lang_id).first
    @result = !vn.hide_flg
    vn.update(hide_flg: !vn.hide_flg)
  end

  def lang
    lang_id = params[:lang][:selectlangid]
    val = params[:lang][:val]
    txt = VocabTable.where(hide_flg: false, vocab_read: val).first
    @text = txt.vocab_nations.where(lang: lang_id) if txt.present?
    @text ||= ''
    render 'lang'
  end

  private

  def goi_params
    params.require(:vocab_table).permit(
      vocab_nations_attributes: [
        :id,
        :nation_code,
        :example
      ]
    )
  end
end
