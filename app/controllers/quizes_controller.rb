class QuizesController < ApplicationController
  def index
    @quizData = VocabStore.select("vocab_stores.vocab_read, vocab_stores.vocab_code, vocab_stores.nation_vocab, vocab_stores.vocab_org")
    .joins(:vocab_mycards)
    .select("vocab_stores.vocab_read, vocab_stores.vocab_code, vocab_stores.nation_vocab")
    .where("vocab_mycards.vocab_org = vocab_stores.vocab_org").shuffle
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
  

  def result
    # Fetch the relevant data from the database
    total_mycards = VocabMycard.count
    level_1_mycards = VocabMycard.where(mycard_level: 1).count
    
    # Calculate the percentage
    percentage_level_1 = (level_1_mycards.to_f / total_mycards) * 100

    
    # You can then pass this percentage value to your view
    @percentage_level_1 = percentage_level_1
  
    respond_to do |format|
      format.json { render json: { success: true, percentage: @percentage_level_1, correct: level_1_mycards, total: total_mycards, message: "Continue your study to get sucess!" } }
    end
  end
  
end
