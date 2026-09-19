class QuizesController < ApplicationController
  MAX_QUESTIONS = 20
  OPTIONS_COUNT = 4

  def index
  end

  def period
    # ① 期間指定あり → mycard 起点
    source = current_user.vocab_mycards
               .joins(:vocab_table)
               .where(updated_at: period_range(params[:period]))
               .select(:vocab_read, :vocab_code).select("vocab_tables.id as vocab_table_id")
    source = source.joins(vocab_table: :vocab_nations)
               .where(vocab_nations: { hide_flg: false, lang: current_user.lang_id })
               .select(:nation_code) if current_user.lang_id != 'JP'
    @quiz_data = make_quiz(source)
    render :show
  end

  def jlpt
    # ② JLPT 指定 → vocab_table 起点（mycard に縛られない）
    source = VocabTable.where(jlpt_level: params[:jlpt])
               .select(:vocab_read, :vocab_code).select("vocab_tables.id as vocab_table_id")
    source = source.joins(:vocab_nations).where(vocab_nations: { hide_flg: false, lang: current_user.lang_id })
               .select(:nation_code) if current_user.lang_id != 'JP'
    @quiz_data = make_quiz(source)
    render :show
  end

  def genre
    # ③ ジャンル指定 → 中間テーブル経由
    source = VocabTable.joins(:vocab_genre_contents).where(vocab_genre_contents: { vocab_genre_id: params[:genre_id] })
               .select(:vocab_read, :vocab_code).select("vocab_tables.id as vocab_table_id")
    source = source.joins(:vocab_nations).where(vocab_nations: { hide_flg: false, lang: current_user.lang_id })
               .select(:nation_code) if current_user.lang_id != 'JP'
    @quiz_data = make_quiz(source)
    render :show
  end

    # ④ デフォルト → mycard 起点
  def show
    source = current_user.vocab_mycards.select(:vocab_read, :vocab_code).select("vocab_tables.id as vocab_table_id")
    source = source.joins(vocab_table: :vocab_nations).where(vocab_nations: { hide_flg: false, lang: current_user.lang_id })
              .select(:nation_code) if current_user.lang_id != 'JP'
    @quiz_data = make_quiz(source)
  end
  
  def make_quiz(source)
    # ===== 共通処理 =====
    vocab_tables = source.shuffle.take(MAX_QUESTIONS)

    # ===== 正解プール =====
    answer_pool = 
      if current_user.lang_id != 'JP'
        answer_pool = vocab_tables.map(&:nation_code)
      else
        answer_pool = vocab_tables.map(&:vocab_read)
      end

    # ===== クイズデータ =====
    vocab_tables.map do |vocab|
      correct = current_user.lang_id != 'JP' ? vocab.nation_code : vocab.vocab_read

      if correct.present?
        incorrect = answer_pool - [correct]
        {
          id: vocab.vocab_table_id,
          word: vocab.vocab_code,
          read: vocab.vocab_read,
          correct: correct,
          options: ([correct] + incorrect.sample(OPTIONS_COUNT - 1)).shuffle
        }
      end
    end
  end

  # 正誤更新（mycard がなければ作る）
  def next_ques
    mycard = current_user.vocab_mycards.find_or_initialize_by(vocab_table_id: params[:quiz][:id])
    quiz = params[:quiz]

    mycard.update!(
      mycard_level: (quiz['correct_'+quiz[:index]] == quiz['answer_'+quiz[:index]] ? 1 : 0),
      updated_at: Time.current
    )
  end

  private

  # 期間指定用
  def period_range(period)
    case period
    when '1d' then 1.day.ago..Time.current
    when '1m' then 1.month.ago..Time.current
    when '3m' then 3.months.ago..Time.current
    when 'all' then 1.years.ago..Time.current
    else nil
    end
  end
end
