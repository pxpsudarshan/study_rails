class GoisController < ApplicationController
  def index
    @breadcrumbs = []
    add_breadcrumb(t('breadcrumbs.gois'))
    if params[:goi][:goi].present?
      goi = params[:goi][:goi]
      vocab_code = ''
      jlpt_level = ''
      gois = ReadStore.where(read_code: goi).order(:read_org).select(:read_org, :read_vocab, :vocab_code, :read_code, :vocab_org).first
      @count = 0
      if gois.present?
          logger.info("count "+gois.read_vocab.count.to_s)

        if gois.read_vocab.count > 1
          @gois = []
          gois.read_vocab.each do |vocab|
            vocab_org = vocab["vocab_org"]
            lang_text = ''
            vocab_store = VocabStore.find_by(vocab_org: vocab_org)
            #lang_text = vocab_store.nation_vocab["VN"].join(",") if vocab_store.present? && vocab_store.nation_vocab.present?
            mycard = current_user.vocab_mycards.where(vocab_code: vocab["vocab_code"]).first
            vocab_mycard = mycard.present? ? '⭐️' : ''
            arr = {
              vocab_org: vocab_org,
              vocab_code: vocab["vocab_code"],
              vocab_mycard: vocab_mycard,
              lang_vocab: (vocab_store["jlpt_level"]||'N'),
            }
            @gois << arr
            vocab_code = vocab["vocab_code"]
          end
#          logger.info(@gois.to_s)
          @count = @gois.count
        end

        if gois.read_vocab.count == 1
          vocab_org = gois["vocab_org"]
#          logger.info("vocab_org "+vocab_org.to_s)
          vocab = VocabStore.find_by(vocab_org: vocab_org)
          vocab_code = vocab["vocab_code"]
          jlpt_level = vocab["jlpt_level"]
          @gois = {
            vocab_read: vocab["vocab_read"],
            vocab_code: vocab_code,
            unit_sheet: (vocab["jlpt_level"]||'N'),
            jlpt_level: jlpt_level,
            vocab_kanji: vocab["vocab_kanji"]
          }
          @count = 1
          @mycard = current_user.vocab_mycards.where(vocab_code: vocab_code).first if @count != 0
          @vocab_mycard = @mycard.present? ? '⭐️' : '☆'
          @mycard = current_user.vocab_mycards.new(jlpt_level: jlpt_level, kanji_body: vocab_code.split("").join(",") , vocab_org: vocab_org) if @mycard.blank?
        end

      end
    end if params[:goi].present?
  end

  def vocab_double
    if params[:goi][:vocab_org].present?
        vocab_org = params[:goi][:vocab_org]
#        logger.info("vocab_org "+vocab_org.to_s)
        vocab = VocabStore.find_by(vocab_org: vocab_org)
        vocab_code = vocab["vocab_code"]
        jlpt_level = vocab["jlpt_level"]
        @gois = {
          vocab_read: vocab["vocab_read"],
          vocab_code: vocab_code,
          unit_sheet: (vocab["jlpt_level"]||'N'),
          jlpt_level: jlpt_level,
          vocab_kanji: vocab["vocab_kanji"]
        }
        @count = 1
        @mycard = current_user.vocab_mycards.where(vocab_code: vocab_code).first if vocab.present?
        @vocab_mycard = @mycard.present? ? '⭐️' : '☆'
        @mycard = current_user.vocab_mycards.new(jlpt_level: jlpt_level, kanji_body: vocab_code.split("").join(",") , vocab_org: vocab_org) if @mycard.blank?
    end if params[:goi].present?
  end

  def lang
    lang_id = params[:lang][:selectlangid]
    val = params[:lang][:val]
    txt = VocabStore.where(vocab_read: val).first
    @text = ''
    @text = txt.nation_vocab[lang_id].join(',') if txt.present? && txt.nation_vocab.present? && txt.nation_vocab[lang_id].present?
    render 'lang'
  end
end
