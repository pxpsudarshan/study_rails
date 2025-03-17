class SpecifiedVocabsController < ApplicationController
  def index
    # Initialize breadcrumbs for specified vocabulary
    @breadcrumbs = []
    add_breadcrumb(t('breadcrumbs.specified_vocabs'))
    @specific_vocab = SpecifiedVocabA.order(:sort)
  end

  def vocab_word
    add_breadcrumb(t('breadcrumbs.specified_vocabs'), specified_vocabs_path)
    add_breadcrumb(t('breadcrumbs.vocabulary'))
    sva = SpecifiedVocabA.find(params[:id])
    @tokutei_bs = sva.specified_vocab_bs.order(frequency_count: :desc)
  end

  def page_mylang
    add_breadcrumb(t('breadcrumbs.specified_vocabs'), specified_vocabs_path)
    add_breadcrumb(t('breadcrumbs.language'))
    vocab_code = params[:vocab_code]
    @vocab_stores = VocabStore.where(vocab_code: vocab_code).order(:vocab_org)  
  end
end
