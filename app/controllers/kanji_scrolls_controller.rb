class KanjiScrollsController < ApplicationController
  def index
    if params[:kanji_id].blank?
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
    if params[:kanji][:kanji_id].present?
      id = params[:kanji][:kanji_id]
      @gois = []
      vocab = KanjiTable.find(id)
      vocab.vocab_tables.each do |vocab|
        vocab_code = vocab.vocab_code
        mycard = current_user.vocab_mycards.where(vocab_table_id: vocab.id).first
        vocab_mycard = mycard.present? ? '⭐️' : '☆'
        jlpt_level = vocab.jlpt_level
        arr = {
#          unit_sheet: vocab["unit_sheet"],
          vocab_code: (vocab_code+" "+'N'+(jlpt_level.to_s)),
          vocab_id:  vocab.id,
          parts_body: vocab.kanji_body,
          eng_mean: vocab.vocab_nations.where(lang: 'EN').first&.nation_code,
          read_code: vocab.vocab_read
        }
        @gois << arr
      end
      @count = @gois.length
    end if params[:kanji].present?    
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
