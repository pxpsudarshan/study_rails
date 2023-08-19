class MenusController < ApplicationController
def index
  @quizData = VocabStore.select("vocab_stores.vocab_read, vocab_stores.vocab_code, vocab_stores.nation_vocab")
  .joins(:vocab_mycards)
  .select("vocab_stores.vocab_read, vocab_stores.vocab_code, vocab_stores.nation_vocab")
  .where("vocab_mycards.vocab_org = vocab_stores.vocab_org")


#  @question = @quizData.first["vocab_read"] # Assuming "vocab_read" is a field in the table
end


end
