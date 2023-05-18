class UsersController < ApplicationController
  before_action :parent, except: [:index, :new]

  def index
    @users = User.where(company_flg: true)
    @users = @users.where(userid: params[:search][:userid]) if params[:search].present? && params[:search][:userid].present?
    @users = @users.page(params[:page]).per(params[:per])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    @user = User.new
  end

  def show
  end

  def edit
  end

  def update
    @user.assign_attributes(user_params)
    begin
      ActiveRecord::Base.transaction() do
        if @user.save
          redirect_to users_path, flash: {success: t('message.success_completed')}
        else
          render 'edit'
        end
      end
    rescue => e
      logger.error(e.message)
      redirect_to users_path, flash: {alert: e.message}
    end
  end

  def create
    @user = User.new(user_params)
    begin
      ActiveRecord::Base.transaction() do
        if @user.save
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

  def destroy
    begin
      ActiveRecord::Base.transaction() do
        @user.destroy!
        redirect_to users_path
      end
    rescue => e
      logger.error(e.message)
      redirect_to users_path, flash: {alert: e.message}
    end
  end

  def new_store
#    @user.company_middle_stores.new
    @stores = @user.company_middle_stores.new
  end

  def create_store
    stores = []
    user_params[:company_middle_stores_attributes].each do |key, value|
      stores << value.except(:_destroy)
    end
    @stores = @user.company_middle_stores.new(stores)
    begin
      ActiveRecord::Base.transaction() do
        if @user.save
          redirect_to users_path, flash: {success: t('message.success_completed') }
        else
          render 'new_store'
        end
      end
    rescue => e
      logger.error(e.message)
      redirect_to users_path, flash: {alert: e.message}
    end
  end

  def new_job_profile
#    @user.company_middle_stores.new
    @job_profiles = @user.job_profiles.new
  end

  def create_job_profile
    job_profiles = []
    user_params[:job_profiles_attributes].each do |key, value|
      job_profiles << value.except(:_destroy)
    end
    @job_profiles = @user.job_profiles.new(job_profiles)
    begin
      ActiveRecord::Base.transaction() do
        if @user.save
          redirect_to users_path, flash: {success: t('message.success_completed') }
        else
          render 'new_job_profile'
        end
      end
    rescue => e
      logger.error(e.message)
      redirect_to users_path, flash: {alert: e.message}
    end
  end

  # new job_search ADD start
  def new_job_search

  end

  # new_job_search ADD END
  #Add 20230513
  def new_student_profile
    @select_profiles = @user.student_profiles.new
  end

  def create_job_profile
    student_profiles = []
    user_params[:student_profiles_attributes].each do |key, value|
      student_profiles << value.except(:_destroy)
    end
    @student_profiles = @user.student_profiles.new(student_profiles)
    begin
      ActiveRecord::Base.transaction() do
        if @user.save
          redirect_to users_path, flash: {success: t('message.success_completed') }
        else
          render 'new_job_profile'
        end
      end
    rescue => e
      logger.error(e.message)
      redirect_to users_path, flash: {alert: e.message}
    end
  end
  #add 20230513
  
  private

  def parent
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(
      :email,
      :password,
      :password_confirmation,
      :sei,
      :mei,
      :sei_kana,
      :mei_kana,
      :mobile,
      :lang_id,
      :jp_level,
      :company_flg, :company_name, :business_type, :company_url, :department,
      company_middle_stores_attributes: [
        :id,
        :occupation,
        :vocab_code,
        :vocab_read,
        :vocab_mean,
        :_destroy
      ],
      job_profiles_attributes: [
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
      ],
      student_profiles_attributes: [
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
