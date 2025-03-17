class MenusController < ApplicationController
  include BreadcrumbsConcern
  include ActionView::Helpers::UrlHelper
  include ActionView::RoutingUrlFor
  include Rails.application.routes.url_helpers
  before_action :set_menu, only: [:show, :edit, :update, :destroy]
  before_action :set_store
  before_action :set_lang, except: []
  
  def index
    @menus = @store.menus
    add_breadcrumb t('breadcrumbs.stores'), stores_path
    add_breadcrumb @store.name, store_path(@store)
    add_breadcrumb t('breadcrumbs.menus')
    # Breadcrumbs are handled by BreadcrumbsConcern
    
#    @tokutei_bs = TokuteiB.where(tokutei_a_id: nil).order(:sort)
    @audio_as = AudioA.order(:sort)
    @chart_data = generate_chart_data
    @line_chart_data = generate_line_chart_data(params[:period] || 'weekly')

  end

  private
  
  def generate_chart_data
    total_studied = current_user.vocab_mycards.count
    learned = current_user.vocab_mycards.where(mycard_level: 1).count
    
    [
      ["Learned", learned],
      ["Studying", total_studied - learned]
    ]
  end

  def generate_line_chart_data(period)
    cards = current_user.vocab_mycards
    end_date = Time.current

    case period
    when 'weekly'
      start_date = 12.weeks.ago.beginning_of_week
      group_by_period(cards, start_date, end_date, 'week')
    when 'monthly'
      start_date = 12.months.ago.beginning_of_month
      group_by_period(cards, start_date, end_date, 'month')
    when 'yearly'
      start_date = 5.years.ago.beginning_of_year
      group_by_period(cards, start_date, end_date, 'year')
    end
  end

  def group_by_period(cards, start_date, end_date, period)
    filtered_cards = cards.where(created_at: start_date..end_date)
    data = initialize_date_range(start_date, end_date, period)
    
    filtered_cards.each do |card|
      key = get_period_key(card.created_at, period)
      data[key] += 1
    end

    data.map { |date, count| [date, count] }.sort_by { |item| item[0] }
  end

  def initialize_date_range(start_date, end_date, period)
    data = {}
    current_date = start_date

    while current_date <= end_date
      data[get_period_key(current_date, period)] = 0
      current_date = advance_date(current_date, period)
    end

    data
  end

  def get_period_key(date, period)
    case period
    when 'week'
      date.beginning_of_week.strftime('%Y-%m-%d')
    when 'month'
      date.beginning_of_month.strftime('%Y-%m-%d')
    when 'year'
      date.beginning_of_year.strftime('%Y-%m-%d')
    end
  end

  def advance_date(date, period)
    case period
    when 'week'
      date + 1.week
    when 'month'
      date + 1.month
    when 'year'
      date + 1.year
    end
  end

  def set_lang
    @lang = current_user.lang_id
  end
end
