class SpecifiedVocabsController < ApplicationController
  def index
    @specific_vocab = SpecifiedVocabA.order(:sort)
  end

  def vocab_word
    if params[:id].present?
      @tokutei_bs = SpecifiedVocabB.where(specified_vocab_a_id: params[:id]).order(frequency_count: :desc)
    end
  end

end
