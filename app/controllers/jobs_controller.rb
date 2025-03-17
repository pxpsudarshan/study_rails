class JobsController < ApplicationController
  def index
    # Initialize breadcrumbs for jobs
    @breadcrumbs = []
    add_breadcrumb(t('breadcrumbs.jobs'))
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

  def apply
    add_breadcrumb(t('breadcrumbs.jobs'), jobs_path)
    add_breadcrumb(t('breadcrumbs.apply'))
    jpc = JobProfileContent.find(params[:job][:id])
    comp = jpc.job_profile.comp
    kaisha_email = comp.email
    kaisha_name = comp.company_name
    Kaisha::JobMailer.notify(kaisha_name, kaisha_email, helpers.occupation_array(jpc.occupation), jpc.job_description, current_user.entry_no).deliver_now
    UserMailer.notify(current_user.name, current_user.email, jpc.job_description).deliver_now
  end
end
