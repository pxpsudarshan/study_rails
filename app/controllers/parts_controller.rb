class PartsController < ApplicationController
  def index
    if params[:kanji].blank?
      @goi = PartsStore.all.order(:parts_stroke)
    end
  end

  def part
    if params[:kanji][:kanji].present?
      parts_org = params[:kanji][:kanji]
      @gois = []
      parts_store = PartsStore.find_by(parts_org: parts_org)
      parts_store.parts_kanji.each do |kanji|
        kanji_code = kanji["kanji_code"]
        kanji_org = kanji["kanji_org"]
        arr = {
          kanji_code: kanji_code,
          kanji_org:  kanji_org,
        }
        @gois << arr
      end
    end if params[:kanji].present?
  end
  
  def parts_kanji
    if params[:kanji][:kanji].present?
      goi = params[:kanji][:kanji]
      @gois = []
      lang = current_user.lang_id
      vocab = KanjiStore.where(kanji_org: goi).first
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
      end if vocab.present? && vocab.kanji_vocab.present?
      @count = @gois.length
    end
  end

  def kanji_vocab
    if params[:kanji][:vocab_org].present?
        vocab_org = params[:kanji][:vocab_org]
        vocab = VocabStore.find_by(vocab_org: vocab_org)
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
