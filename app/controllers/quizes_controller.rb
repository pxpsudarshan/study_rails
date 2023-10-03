class QuizesController < ApplicationController
  def index
    @current_user_quiz = current_user.id

    @quizData = current_user.vocab_mycards.joins(:vocab_store).shuffle
    
    @total_count = @quizData.count

  end

  def next_ques
    vocab_org = params[:vocab_org]
    mycard_level = params[:mycard_level]

    # Find and update all records (including soft-deleted ones) that match the condition
    @questionUpdate = VocabMycard.unscoped.where(vocab_org: vocab_org, user_id: current_user.id).update_all(mycard_level: mycard_level)

  end
end
