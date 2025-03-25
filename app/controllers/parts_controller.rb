class PartsController < ApplicationController
  def index
    @goi = PartsTable.order(:parts_stroke)
  end

  def show
    @gois = PartsTable.find(params[:id]).kanji_tables
  end
  
  def parts_kanji
      id = params[:id]
      @gois = []
      lang = current_user.lang_id
      kanji = KanjiTable.find(id)
      kanji.vocab_tables.each do |vocab|
        vocab_code = vocab.vocab_code
        mycard = current_user.vocab_mycards.where(vocab_table_id: vocab.id).first
        vocab_mycard = mycard.present? ? '⭐️' : '☆'
        jlpt_level = vocab.jlpt_level
        arr = {
 #         unit_sheet: vocab["unit_sheet"],
          vocab_code: (vocab_code+" "+'N'+(jlpt_level.to_s)),
          vocab_id:  vocab.id,
          parts_body: vocab.kanji_body,
          eng_mean: vocab.vocab_nations.where(lang: 'EN').first&.nation_code,
          read_code: vocab.vocab_read
        }
        @gois << arr
      end
      @count = @gois.length
  end

  def kanji_vocab
        id = params[:vocab_id]
        vocab = VocabTable.find(id)
        vocab_code = vocab.vocab_code
        jlpt_level = vocab.jlpt_level
        @gois = {
          vocab_read: vocab.vocab_read,
          vocab_code: vocab_code,
          #unit_sheet: vocab.unit_sheet,
          jlpt_level: 'N'+jlpt_level.to_s,
          vocab_kanji: vocab.kanji_tables,
          eng_mean: vocab.vocab_nations.where(lang: 'EN').first&.nation_code,
          nation_mean: vocab.vocab_nations.where(lang: current_user.lang_id).first&.nation_code,
        }
        @count = 1
        @mycard = current_user.vocab_mycards.where(vocab_table_id: vocab.id).first
        @vocab_mycard = @mycard.present? ? '⭐️' : '☆'
        @mycard = current_user.vocab_mycards.create!(vocab_table_id: id) if @mycard.blank?
  end
end
