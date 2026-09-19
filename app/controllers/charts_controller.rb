class ChartsController < ApplicationController
  before_action :parent

  def index
    @chart_data       = @service.summary_chart
    @line_chart_data  = @service.line_chart(params[:period] || 'weekly')
    @jlpt_chart_data  = @service.jlpt_chart
    @genre_chart_data = @service.genre_chart
  end
  
  def sub_genre_chart
    @sub_genres = @service.sub_genre_chart(params)
  end

  private

  def parent
    @service = ChartService.new(current_user)
  end
end
