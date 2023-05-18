class ForeignsController < ApplicationController
  def index
    if params[:goi][:goi].present?
      goi = params[:goi][:goi]
      @gois = []
          lang = current_user.lang_id
          vocabs = VocabStore.where("nation_vocab ->> ? ILIKE ?", lang, '%'+goi+'%')
          vocabs.each do |vocab|
          vocab_code = vocab["vocab_code"]
          vocab_org = vocab["vocab_org"]
          lang_vocab = vocab["nation_vocab"][lang].join(",")
          arr = {
            vocab_read: vocab["vocab_read"],
            vocab_code: (vocab_code+" "+lang_vocab),
            vocab_org:  vocab_org,
            lang_vocab: lang_vocab
          }
          @gois << arr
        end
        @count = vocabs.count

    end if params[:goi].present?
  end

  def kanji_vocab
    if params[:kanji][:vocab_org].present?
        vocab_org = params[:kanji][:vocab_org]
        vocab = VocabStore.find_by(vocab_org: vocab_org)
        vocab_code = vocab["vocab_code"]
        jlpt_level = vocab["jlpt_level"]||"N?"
        @gois = {
          vocab_read: vocab["vocab_read"],
          vocab_code: vocab_code,
          unit_sheet: vocab["unit_sheet"],
          jlpt_level: jlpt_level,
          vocab_kanji: vocab["vocab_kanji"]
        }
        @count = 1
        @mycard = current_user.vocab_mycards.where(vocab_code: vocab_code).first if vocab.present?
        @vocab_mycard = @mycard.present? ? '⭐️' : '☆'
        @mycard = current_user.vocab_mycards.new(jlpt_level: jlpt_level, kanji_body: vocab_code.split("").join(",") , vocab_org: vocab_org) if @mycard.blank?
    end if params[:kanji].present?
  end
end
