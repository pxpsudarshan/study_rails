class SpecifiedVocabsController < ApplicationController
  def index
    @specific_vocab = SpecifiedVocabA.order(:sort)
  end

  def vocab_word
    sva = SpecifiedVocabA.find(params[:id])
    @tokutei_bs = sva.specified_vocab_bs.order(frequency_count: :desc)
  end

  def page_mylang
    vocab_code = params[:vocab_code]
    @vocab_stores = VocabStore.where(vocab_code: vocab_code).order(:vocab_org)  
  end
end
