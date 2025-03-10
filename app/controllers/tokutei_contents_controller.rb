class TokuteiContentsController < ApplicationController
  def index
    if params[:id].present?
      @tokutei = Tokutei.find(params[:id])
    end
  end

  def show
    max_questions = 20

    quizdatas = TokuteiQuestion.where(tokutei_id: params[:id]).all
    # Shuffle the specified_skills
    datas = quizdatas.shuffle
    @datas = datas.take(max_questions)

    # Count the total number of shuffled records
    @total_count = @datas.count

    @id = quizdatas.first.tokutei.id if @datas.count > 0
  end
end
