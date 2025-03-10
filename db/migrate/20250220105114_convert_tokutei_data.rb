class ConvertTokuteiData < ActiveRecord::Migration[7.0]
  def up
    RecordWithOperator.operator = User.first
    id = '60ba2b1a-628d-4c9e-8de3-a695cebdb32e'
    Tokutei.create!({
      id: id,
      title: '特定技能試験',
      sort: 1,
      languages_attributes: [{
        language: 'EN',
        skip_flg: true,
        content: 'Specific Skills Test'
      }]
    })

    SswTitlea.order(:sort).each do |t|
      Tokutei.create!({
        id: t.id,
        tokutei_id: id,
        sort: t.sort||0,
        title: t.titlea_name,
        languages_attributes: [{
            language: 'EN',
            skip_flg: true,
            content: (t.titlea_eng||'')
          }]
      })
    end
    SswTitlec.order(:sort).each do |t|
      Tokutei.create!({
        id: t.id,
        tokutei_id: t.ssw_titleb.ssw_titlea.id,
        sort: t.sort||0,
        title: t.titlec_name,
        languages_attributes: [{
            language: 'EN',
            skip_flg: true,
            content: (t.titlec_eng||'')
          }]
      })
    end
    SswProb.joins(:ssw_title).order(:sort).each do |t|
      tq = TokuteiQuestion.create!({
        tokutei_id: t.ssw_title.ssw_titlec_id,
        title: t.ssw_title.title_name,
        content: t.prob_txt,
        content_hex: t.prob_hex,
        image_flg: t.image_flag||false,
        languages_attributes: [{
          language: 'EN',
          content: t.prob_eng.blank? ? 'Empty' : t.prob_eng,
          skip_flg: true,
        },{
          language: 'BD',
          content: t.prob_nation ? t.prob_nation["BD"]||'Empty' : 'Empty',
          skip_flg: true,
        },{
          language: 'CN',
          content: t.prob_nation ? t.prob_nation["CN"]||'Empty' : 'Empty',
          skip_flg: true,
        },{
          language: 'ID',
          content: t.prob_nation ? t.prob_nation["ID"]||'Empty' : 'Empty',
          skip_flg: true,
        },{
          language: 'MM',
          content: t.prob_nation ? t.prob_nation["MM"]||'Empty' : 'Empty',
          skip_flg: true,
        },{
          language: 'NP',
          content: t.prob_nation ? t.prob_nation["NP"]||'Empty' : 'Empty',
          skip_flg: true,
        },{
          language: 'RU',
          content: t.prob_nation ? t.prob_nation["RU"]||'Empty' : 'Empty',
          skip_flg: true,
        },{
          language: 'VN',
          content: t.prob_nation ? t.prob_nation["VN"]||'Empty' : 'Empty',
          skip_flg: true,
        }],
        tokutei_explain_attributes: {
          content: t.ssw_expl.expl_txt,
          content_hex: t.ssw_expl.expl_hex,
          languages_attributes: [{
            language: 'EN',
            content: t.ssw_expl.present? && t.ssw_expl.expl_eng.present? ? t.ssw_expl.expl_eng : 'Empty',
            skip_flg: true,
          },{
            language: 'BD',
            content: t.ssw_expl.expl_nation ? t.ssw_expl.expl_nation["BD"]||'Empty' : 'Empty',
            skip_flg: true,
          },{
            language: 'CN',
            content: t.ssw_expl.expl_nation ? t.ssw_expl.expl_nation["CN"]||'Empty' : 'Empty',
            skip_flg: true,
          },{
            language: 'ID',
            content: t.ssw_expl.expl_nation ? t.ssw_expl.expl_nation["ID"]||'Empty' : 'Empty',
            skip_flg: true,
          },{
            language: 'MM',
            content: t.ssw_expl.expl_nation ? t.ssw_expl.expl_nation["MM"]||'Empty' : 'Empty',
            skip_flg: true,
          },{
            language: 'NP',
            content: t.ssw_expl.expl_nation ? t.ssw_expl.expl_nation["NP"]||'Empty' : 'Empty',
            skip_flg: true,
          },{
            language: 'RU',
            content: t.ssw_expl.expl_nation ? t.ssw_expl.expl_nation["RU"]||'Empty' : 'Empty',
            skip_flg: true,
          },{
            language: 'VN',
            content: t.ssw_expl.expl_nation ? t.ssw_expl.expl_nation["VN"]||'Empty' : 'Empty',
            skip_flg: true,
          }],
        },
      })
      tq.image.attach(io: StringIO.new(Base64.decode64(t.img_hex)), filename: t.ssw_title.title_name) if t.image_flag
      TokuteiAnswer.create!([{
        sort: 1,
        tokutei_question_id: tq.id,
        title: 'title',
        correct_flg: t.judge_flag,
        content: 'Yes',
      },{
        sort: 2,
        tokutei_question_id: tq.id,
        title: 'title',
        correct_flg: !t.judge_flag,
        content: 'No',
      }]) if t.ssw_problimbs.blank? # only yes/no
      t.ssw_problimbs.order(:sort).each do |pb|
        expl = pb.ssw_prob.ssw_expl.ssw_expllimbs.where(sort: pb.sort).first
        TokuteiAnswer.create!({
          sort: pb.sort,
          tokutei_question_id: tq.id,
          title: 'title',
          correct_flg: pb.judge_flag,
          content: pb.problimb_txt,
          tokutei_explain_attributes: {
            content: expl.expllimb_txt,
            content_hex: expl.expllimb_hex,
            languages_attributes: [{
              language: 'EN',
              content: expl.expllimb_eng.present? ? expl.expllimb_eng : 'Empty',
              skip_flg: true,
            },{
            language: 'BD',
            content: expl.expllimb_nation ? expl.expllimb_nation["BD"]||'Empty' : 'Empty',
            skip_flg: true,
            },{
            language: 'CN',
            content: expl.expllimb_nation ? expl.expllimb_nation["CN"]||'Empty' : 'Empty',
            skip_flg: true,
            },{
            language: 'ID',
            content: expl.expllimb_nation ? expl.expllimb_nation["ID"]||'Empty' : 'Empty',
            skip_flg: true,
            },{
            language: 'MM',
            content: expl.expllimb_nation ? expl.expllimb_nation["MM"]||'Empty' : 'Empty',
            skip_flg: true,
            },{
            language: 'NP',
            content: expl.expllimb_nation ? expl.expllimb_nation["NP"]||'Empty' : 'Empty',
            skip_flg: true,
            },{
            language: 'RU',
            content: expl.expllimb_nation ? expl.expllimb_nation["RU"]||'Empty' : 'Empty',
            skip_flg: true,
            },{
            language: 'VN',
            content: expl.expllimb_nation ? expl.expllimb_nation["VN"]||'Empty' : 'Empty',
            skip_flg: true,
            }],
          },
        })
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
