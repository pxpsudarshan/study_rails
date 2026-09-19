class Kaisha::ProgressController < ApplicationController
  before_action :parent, only: [:chart, :sub_genre_chart]

  def index
    # 現在のユーザーが作成したユーザー一覧取得（デフォルト表示件数は10件）
    if current_comp.access_type == Comp::ACCESS_TYPE::KANRIGAISHA || current_comp.access_type == Comp::ACCESS_TYPE::PARTNER
      if current_comp.access_type == Comp::ACCESS_TYPE::PARTNER
        comps = current_comp.comps
        if comps.present?
          comp_ids = [current_comp.id] + comps.ids
          @users = User.where(comp_id: comp_ids).order(:comp_id).order(:sei, :mei)
          @users = @users.where(comp_id: params[:search][:comp_id]) if params[:search].present? && params[:search][:comp_id].present? && comp_ids.include?(params[:search][:comp_id])
        else
          @users = User.where(comp_id: current_comp.id).order(:sei, :mei)
        end
      else
        @users = User.order(:comp_id).order(:sei, :mei)
        @users = @users.where(comp_id: params[:search][:comp_id]) if params[:search].present? && params[:search][:comp_id].present?
      end
    else
      @users = User.where(comp_id: current_comp.id).order(:sei, :mei)
    end
    @users = @users.page(params[:page]).per(params[:per] || 10)
  end

  def chart
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
    user = User.find_by(id: params[:user_id])
    @service = ChartService.new(user)
  end
end
