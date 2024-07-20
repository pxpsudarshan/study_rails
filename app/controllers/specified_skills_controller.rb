class SpecifiedSkillsController < ApplicationController
  def index
    if params[:id].present?
      @tokutei_bs = TokuteiB.where(tokutei_a_id: params[:id]).order(:sort)
    end
  end

  def show
    max_questions = 20

    quizdatas = TokuteiC.where(tokutei_b_id: params[:id]).all
    # Shuffle the specified_skills
    datas = quizdatas.shuffle
    @datas = datas.take(max_questions)

    # Count the total number of shuffled records
    @total_count = @datas.count

    @id = quizdatas.first.tokutei_b.tokutei_a_id
  end
end
