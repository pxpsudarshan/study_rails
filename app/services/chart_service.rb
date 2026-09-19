class ChartService
  def initialize(user)
    @user = user
  end

  def summary_chart
    total = @user.vocab_mycards.count
    learned = @user.vocab_mycards.where(mycard_level: 1).count

    [
      ["Learned", learned],
      ["Studying", total - learned]
    ]
  end

  def line_chart(period)
    cards = @user.vocab_mycards
    end_date = Time.current

    case period
    when 'weekly'
      start_date = 12.weeks.ago.beginning_of_week
      unit = 'week'
    when 'monthly'
      start_date = 12.months.ago.beginning_of_month
      unit = 'month'
    when 'yearly'
      start_date = 5.years.ago.beginning_of_year
      unit = 'year'
    end

    [
      { name: "Learning", data: group_by_period(cards, start_date, end_date, unit, :updated_at) },
      { name: "Studying", data: group_by_period(cards, start_date, end_date, unit, :created_at) }
    ]
  end

  def jlpt_chart
    levels = { "N5"=>5, "N4"=>4, "N3"=>3, "N2"=>2, "N1"=>1 }
    read = {}; learned = {}; remaining = {}

    levels.each do |label, level|
      total = VocabTable.where(jlpt_level: level).count
      user_cards = @user.vocab_mycards.joins(:vocab_table)
                        .where(vocab_tables: { jlpt_level: level })

      r = user_cards.where(mycard_level: 0).count
      l = user_cards.where(mycard_level: 1).count
      rem = [total - r - l, 0].max

      read[label]      = percent(r, total)
      learned[label]   = percent(l, total)
      remaining[label] = percent(rem, total)
    end

    [
      { name: "Read", data: read },
      { name: "Learned", data: learned },
      { name: "Remaining", data: remaining }
    ]
  end


  def genre_chart
    result = {}
    genres = VocabGenre.where(vocab_genre_id: nil).order(:sort)
    genres.each do |grs|
      table_ids = [grs.id]
      total = 0
      read_count    = 0
      learned_count = 0
      remaining     = 0
      while id = table_ids.shift
        genre = VocabGenre.find(id)

        total += genre.vocab_tables.count

        cards = @user.vocab_mycards
                   .joins(vocab_table: :vocab_genre_contents)
                   .where(vocab_genre_contents: { vocab_genre_id: genre.id })

        counts = cards.group(:mycard_level).count

        read_count    += counts[0] || 0
        learned_count += counts[1] || 0
        remaining += [genre.vocab_tables.count - (counts[0] || 0) - (counts[1] || 0), 0].max

        table_ids += genre.sub_genres.where(hide_flg: false).pluck(:id)
      end
      result[grs.title] = {
        id: grs.id,
        read: percent(read_count, total),
        learned: percent(learned_count, total),
        remaining: percent(remaining, total),
        user_id: @user.id
      }
    end
    result
  end

  def sub_genre_chart(params)
    sub_genres = []
    genres = VocabGenre.where(vocab_genre_id: params[:genre_id])
    genres.each do |grs|
      table_ids = [grs.id]
      total = 0
      progress = 0
      while id = table_ids.shift
        genre = VocabGenre.find(id)

        total += genre.vocab_tables.count

        cards = @user.vocab_mycards
                   .joins(vocab_table: :vocab_genre_contents)
                   .where(vocab_genre_contents: { vocab_genre_id: genre.id })

        counts = cards.group(:mycard_level).count

        read_count    = counts[0] || 0
        learned_count = counts[1] || 0
        progress += read_count  + learned_count

        table_ids += genre.sub_genres.where(hide_flg: false).pluck(:id)
      end
      sub_genres << {
        id: grs.id,
        name: grs.title,
        progress: percent(progress, total),
        user_id: @user.id
      }
    end
    sub_genres
  end

  private

  def percent(value, total)
    total.zero? ? 0 : (value * 100.0 / total).round(1)
  end

  def group_by_period(cards, start_date, end_date, period, column)
    data = initialize_range(start_date, end_date, period)
    cards.where(column => start_date..end_date).each do |card|
      data[key(card[column], period)] += 1
    end
    data
  end

  def initialize_range(start_date, end_date, period)
    data = {}
    d = start_date
    while d <= end_date
      data[key(d, period)] = 0
      d = advance(d, period)
    end
    data
  end

  def key(date, period)
    case period
    when 'week'  then date.beginning_of_week.strftime('%Y-%m-%d')
    when 'month' then date.beginning_of_month.strftime('%Y-%m-%d')
    when 'year'  then date.beginning_of_year.strftime('%Y-%m-%d')
    end
  end

  def advance(date, period)
    date + { 'week'=>1.week, 'month'=>1.month, 'year'=>1.year }[period]
  end
end
