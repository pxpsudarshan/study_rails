class KanjiUnitsController < ApplicationController
  def index
    if params[:kanji].blank?
      @gois = []
      kanji_stores = KanjiTable.all
      kanji_stores.each do |kanji|
        kanji_code = kanji.kanji_code
        kanji_id = kanji.id
        arr = {
          kanji_code: kanji_code,
          kanji_id:  kanji_id,
        }
        @gois << arr
      end
    end
    if params[:kanji][:selectkanjiunit].present?
      unit_id = params[:kanji][:selectkanjiunit]
      @gois = []
      kanji_stores = KanjiTable.where(kanji_sheet: unit_id)
      kanji_stores.each do |kanji|
        arr = {
          kanji_code: kanji.kanji_code,
          kanji_id:  kanji.id,
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
          eng_mean: vocab.vocab_nations.where(lang: 'EN').first&.nation_code,
        }
        @gois << arr
      end
      @count = @gois.length
    end
  end
# not used
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
