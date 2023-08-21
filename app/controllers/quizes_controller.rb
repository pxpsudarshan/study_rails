class QuizesController < ApplicationController
  def index
    @current_user_quiz = current_user.id

    @quizData = VocabStore.select("vocab_stores.vocab_read, vocab_stores.vocab_code, vocab_stores.nation_vocab, vocab_stores.vocab_org")
      .joins(:vocab_mycards)
      .select("vocab_stores.vocab_read, vocab_stores.vocab_code, vocab_stores.nation_vocab")
      .where("vocab_mycards.vocab_org = vocab_stores.vocab_org")
      .where("vocab_mycards.user_id = ?", @current_user_quiz)
      .shuffle
    
    @total_count = @quizData.count
    
  end

  def next_ques
    vocab_org = params[:vocab_org]
    mycard_level = params[:mycard_level]
  
    # Find and update all records (including soft-deleted ones) that match the condition
    @questionUpdate = VocabMycard.unscoped.where(vocab_org: vocab_org).update_all(mycard_level: mycard_level)
  
    # Optionally, if you want to retrieve the updated records
    @updated_cards = VocabMycard.where(vocab_mycard_org: vocab_org)

  end  
end
