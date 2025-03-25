class QuizesController < ApplicationController
  def index
    @current_user_quiz = current_user.id
    @quizData = current_user.vocab_mycards.joins(:vocab_table).shuffle
    @total_count = @quizData.count
  end

  def next_ques
    mycard_level = params[:mycard_level]

    # Find and update all records (including soft-deleted ones) that match the condition
    @questionUpdate = current_user.vocab_mycards.with_deleted.where(vocab_table_id: params[:id]).first.update!(mycard_level: mycard_level)
  end
end
