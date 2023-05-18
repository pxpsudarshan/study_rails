class JobProfilesController < ApplicationController
  def index
  end

  def excel_upload
    redirect_to new_job_profile_user_path(current_user), flash: {alert: t('message.select_file')} and return if params[:import].blank?
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
    redirect_to users_path, flash: {success: t('message.success_completed')}
  end

  def new
    @job = current_user.job_profiles.new
  end

  def create
    @job = current_user.job_profiles.new(job_params)
    begin
      ActiveRecord::Base.transaction() do
        if @job.save
          redirect_to users_path, flash: {success: t('message.success_completed')}
        else
          render 'new'
        end
      end
    rescue => e
      logger.error(e.message)
      redirect_to users_path, flash: {alert: e.message}
    end
  end

private

  def job_params
    params.require(:job_profile).permit(
      :ad_title,
      :occupation,
      :location,
      :employment_sts,
      :visa_support,
      :salary,
      :job_description,
      :desire_qualification,
      :visa_type
    )
  end
end
