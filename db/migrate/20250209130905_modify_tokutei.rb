class ModifyTokutei < ActiveRecord::Migration[7.0]
  def up
    RecordWithOperator.operator = User.first
    add_column :tokutei_questions, :content_hex, :text
    add_column :tokutei_explains, :content_hex, :text

    TokuteiA.order(:sort).each do |t|
      Tokutei.create!({
        id: t.id,
        title: t.title,
        sort: t.sort,
        languages_attributes: [{
            language: 'EN',
            skip_flg: true,
            content: t.src_eng
          }]
      })
    end
    TokuteiB.order(:sort).each do |t|
      Tokutei.create!({
        id: t.id,
        tokutei_id: t.tokutei_a_id,
        title: t.title,
        sort: t.sort,
        languages_attributes: [{
            language: 'EN',
            content: t.src_eng,
            skip_flg: true
          }]
      })
    end
    TokuteiC.order(:tokutei_b_id).each do |t|
      TokuteiQuestion.create!({
        tokutei_id: t.tokutei_b_id,
        title: t.title,
        content: t.question_jp,
        content_hex: t.question_jp_hex,
        languages_attributes: [{
          language: 'EN',
          content: t.question_eng,
          skip_flg: true,
        },{
          language: 'VN',
          content: t.question_nation["VN"],
          skip_flg: true,
        }],
        tokutei_explain_attributes: {
          content: t.explain_jp,
          content_hex: t.explain_jp_hex,
          languages_attributes: [{
            language: 'EN',
            content: t.explain_eng,
            skip_flg: true,
          },{
          language: 'VN',
          content: t.explain_nation["VN"],
          skip_flg: true,
          }],
        }
      })
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
