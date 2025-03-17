class KanjisController < ApplicationController
  def index
    # Initialize breadcrumbs for kanji listing
    @breadcrumbs = []
    add_breadcrumb(t('breadcrumbs.kanjis'))
    if params[:kanji][:kanji].present?
      goi = params[:kanji][:kanji]
      @gois = []
      lang = current_user.lang_id
      vocab = KanjiStore.where(kanji_code: goi).order(:kanji_org).first
      vocab.kanji_vocab.each do |vocab|
        vocab_code = vocab["vocab_code"]
        vocab_org = vocab["vocab_org"]
        mycard = current_user.vocab_mycards.where(vocab_code: vocab["vocab_code"]).first
        vocab_mycard = mycard.present? ? '⭐️' : '☆'
        vocab_store = VocabStore.find_by(vocab_org: vocab_org)
        jlpt_level = vocab_store["jlpt_level"] if vocab_store.present?
        arr = {
          unit_sheet: vocab["unit_sheet"],
          vocab_code: (vocab_code+" "+(jlpt_level||'')),
          vocab_org:  vocab_org,
        }
        @gois << arr
      end if vocab.present?
      @count = @gois.length
    end if params[:kanji].present?
  end

  def kanji_vocab
    if params[:kanji][:vocab_org].present?
        vocab_org = params[:kanji][:vocab_org]
        vocab = VocabStore.find_by(vocab_org: vocab_org)
        add_breadcrumb(t('breadcrumbs.kanjis'), kanjis_path)
        add_breadcrumb(vocab_org)
        add_breadcrumb(t('breadcrumbs.kanji_vocab'))
        vocab_code = vocab["vocab_code"]
        jlpt_level = vocab["jlpt_level"]||'N?'
        @gois = {
          vocab_read: vocab["vocab_read"],
          vocab_code: vocab_code,
          unit_sheet: vocab["unit_sheet"],
          jlpt_level: jlpt_level,
          vocab_kanji: vocab["vocab_kanji"],
        }
        @count = 1
        @mycard = current_user.vocab_mycards.where(vocab_code: vocab_code).first if vocab.present?
        @vocab_mycard = @mycard.present? ? '⭐️' : '☆'
        @mycard = current_user.vocab_mycards.new(jlpt_level: jlpt_level, kanji_body: vocab_code.split("").join(",") , vocab_org: vocab_org) if @mycard.blank?
    end if params[:kanji].present?
  end
end
