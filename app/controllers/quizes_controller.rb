class QuizesController < ApplicationController
  def index
    @current_user_quiz = current_user.id
    @quizData = current_user.vocab_mycards
                  .joins(:vocab_table)
                  .order(mycard_level: :desc)
                  .to_a
                  .shuffle
    @total_count = @quizData.count
  end

  def next_ques
    param_level = params[:mycard_level].to_i
    vocab_card = current_user.vocab_mycards.with_deleted.find_by(vocab_table_id: params[:id])
    return head :not_found unless vocab_card
  
    current_level = vocab_card.mycard_level.to_i
  
    new_level =
      if param_level == 1
        [current_level + 1, 10].min
      else
        [current_level - 1, 0].max
      end
  
    vocab_card.update!(mycard_level: new_level)
  end
  
end
