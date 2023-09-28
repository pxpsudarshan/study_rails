class Kaisha::JobProfilesController < ApplicationController
  before_action :parent
  
  def index
    if @comp.job_profile.present?
      @jobs = @comp.job_profile.job_profile_contents
      @jobs = @jobs.page(params[:page]).per(params[:per])
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def excel_upload
    redirect_to new_kaisha_job_profile_path(current_user), flash: {alert: t('message.select_file')} and return if params[:import].blank?
    excel_file = params[:import][:excel_file]
    workbook = Creek::Book.new(excel_file.path, original_filename: excel_file.original_filename)#, check_file_extension: false)
    worksheets = workbook.sheets
    worksheet = worksheets[0]
    puts "Reading: #{worksheet.name}"
    worksheet.simple_rows.each_with_index do |hash, idx|
    end

#    excel = Roo::Spreadsheet.open(params[:excel_file].path)
#    sheet = excel.sheet(0)
#    sheet.each_row_streaming do |row|
#    end
    redirect_to new_kaisha_job_profile_path, flash: {success: t('message.success_completed')}
  end

  def new
    @job_profile = @comp.job_profile
    @job_profile ||= @comp.build_job_profile
    @job_profile_contents = @job_profile.job_profile_contents.new
  end

  def create
    @job_profile = @comp.build_job_profile(job_profile_params)
    @job_profile_contents = @job_profile.job_profile_contents
    begin
      ActiveRecord::Base.transaction() do
        if @job_profile.save
          redirect_to new_kaisha_job_profile_path, flash: {success: t('message.success_completed') }
        else
          render 'new'
        end
      end
    rescue => e
      logger.error(e.message)
      redirect_to new_kaisha_job_profile_path, flash: {alert: e.message}
    end
  end

  def edit
    @job_profile = @comp.job_profile
    @job_profile_contents = JobProfileContent.where(id: params[:id])
  end

  def update
    stores = []
    @job_profile = @comp.job_profile
    jpc_id = job_profile_params["job_profile_contents_attributes"]["0"]["id"]
    unless jpc_id.present?
      job_profile_params[:job_profile_contents_attributes].each do |key, value|
        stores << value.except(:_destroy)
      end
      @job_profile_contents = @job_profile.job_profile_contents.new(stores)
    else
      @job_profile.assign_attributes(job_profile_params)
      @job_profile_contents = JobProfileContent.where(id: jpc_id)
    end
    begin
      ActiveRecord::Base.transaction() do
        if @job_profile.save
          if jpc_id.present?
            redirect_to edit_kaisha_job_profile_path(id: jpc_id), flash: {success: t('message.success_completed') }
          else
            redirect_to new_kaisha_job_profile_path, flash: {success: t('message.success_completed') }
          end
        else
          if jpc_id.present?
            render 'edit'
          else
            render 'new'
          end
        end
      end
    rescue => e
      logger.error(e.message)
      redirect_to kaisha_job_profiles_path, flash: {alert: e.message}
    end
  end

#  def update
#    stores = []
#    job_profile_params[:job_profile_contents_attributes].each do |key, value|
#      stores << value.except(:_destroy)
#    end
#    @job_profile = @comp.job_profile
#    @job_profile_contents = @job_profile.job_profile_contents.new(stores)
#    begin
#      ActiveRecord::Base.transaction() do
#        if @job_profile.save
#          redirect_to new_kaisha_job_profile_path, flash: {success: t('message.success_completed') }
#        else
#          render 'new'
#        end
#      end
#    rescue => e
#      logger.error(e.message)
#      redirect_to new_kaisha_job_profile_path, flash: {alert: e.message}
#    end
#  end

  private

  def parent
    @comp = current_comp
  end

  def job_profile_params
    params.require(:job_profile).permit(
      job_profile_contents_attributes: [
        :id,
        :salary,
        :visa_support,
        :visa_type,
        :occupation,
        :year,
        :job_description,
        :_destroy,
        location: [],
        month: [],
      ]
    )
  end
end
