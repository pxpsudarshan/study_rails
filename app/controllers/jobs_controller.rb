class JobsController < ApplicationController
  def index
    if params[:search].present?
      @jobs = JobProfileContent.reorder('')
      @jobs = @jobs.where(year: params[:search][:year]) if params[:search][:year].present?
      @jobs = @jobs.where('month && ARRAY[?]::integer[]', params[:search][:month]) if params[:search][:month].present?
      @jobs = @jobs.where("location && ARRAY[?]::integer[]", params[:search][:location]) if params[:search][:location].present?
      @jobs = @jobs.where(occupation: params[:search][:occupation]) if params[:search][:occupation].present? && params[:search][:occupation].to_i != 0
      @jobs = @jobs.where(salary: params[:search][:salary]) if params[:search][:salary].present?
      @jobs = @jobs.page(params[:page]).per(params[:per])
    end
    respond_to do |format|
      format.html
      format.js
    end
  end
end
