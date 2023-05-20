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

  def submit_job_search
    @SubmitStatus = "done"
    @results = {}
    # Pass the @results variable to the view
    render 'new_job_search'
  end
  
  def get_job_search
    @results = {
      "vacancies" => [
        {
          "company" => "A 株式会社",
          "position" => "Software Engineer",
          "location" => "New York",
          "description" => "is seeking a skilled Software Engineer to join our dynamic team. As a Software Engineer, you will be responsible for developing and maintaining high-quality software applications. This role requires strong programming skills, problem-solving abilities, and a passion for technology.",
          "requirements" => ["Bachelor's degree in Computer Science", "2+ years of experience in software development", "Proficiency in Java and JavaScript"],
          "responsibilities" => ["Design, develop, and test software applications", "Collaborate with cross-functional teams to define project requirements", "Debug and resolve software defects"],
          "info" => "To apply for this position, please send your resume and cover letter to",
          "email" => "A@gmail.com",
          "deadline" => "2023-07-31"
        },
        {
          "company" => "B 株式会社",
          "position" => "Data Analyst",
          "location" => "San Francisco",
          "description" => "is seeking a skilled Software Engineer to join our dynamic team. As a Software Engineer, you will be responsible for developing and maintaining high-quality software applications. This role requires strong programming skills, problem-solving abilities, and a passion for technology.",
          "requirements" => ["Bachelor's degree in Statistics or related field", "Experience with data analysis tools (e.g., Python, R)", "Strong analytical and problem-solving skills"],
          "responsibilities" => ["Design, develop, and test software applications", "Collaborate with cross-functional teams to define project requirements", "Debug and resolve software defects"],
          "info" => "To apply for this position, please send your resume and cover letter to",
          "email" => "B@gmail.com",
          "deadline" => "2023-09-31"
        },
        {
          "company" => "C 株式会社",
          "position" => "Marketing Manager",
          "location" => "London",
          "description" => "is seeking a skilled Software Engineer to join our dynamic team. As a Software Engineer, you will be responsible for developing and maintaining high-quality software applications. This role requires strong programming skills, problem-solving abilities, and a passion for technology.",
          "requirements" => ["Bachelor's degree in Marketing or related field", "5+ years of experience in marketing", "Excellent communication and leadership skills"],
          "responsibilities" => ["Design, develop, and test software applications", "Collaborate with cross-functional teams to define project requirements", "Debug and resolve software defects"],
          "info" => "To apply for this position, please send your resume and cover letter to",
          "email" => "C@gmail.com",
          "deadline" => "2023-10-31"
        }
      ]
    }

    # Pass the @results variable to the view
    render 'new_job_search'
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
