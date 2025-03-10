class ModifyTokuteiB < ActiveRecord::Migration[7.0]
  def up
    RecordWithOperator.operator = User.first
    TokuteiC.order(:tokutei_b_id).each do |t|
      tq = TokuteiQuestion.where(title: t.title).first
      TokuteiAnswer.create!([{
        tokutei_question_id: tq.id,
        title: 'title',
        correct_flg: t.correct_answer == 't' ? true : false,
        content: 'Yes',
      },{
        tokutei_question_id: tq.id,
        title: 'title',
        correct_flg: t.correct_answer == 'f' ? true : false,
        content: 'No',
      }])
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
