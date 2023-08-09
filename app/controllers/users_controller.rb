class UsersController < ApplicationController
  before_action :parent, except: [:index, :new]

  def index
    @users = User.all
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

  def profile
    if @user.profile.blank?
      @user.build_profile
      @user.profile.profile_languages.new
      @user.profile.profile_works.new
    end
  end

  def update_profile
    profile = user_params[:profile_attributes]
    works = profile[:profile_works_attributes]
    profile[:profile_works_attributes] = []
    @user.assign_attributes(profile_attributes: profile)
    @user.profile.assign_attributes(profile_works_attributes: works)
    begin
      ActiveRecord::Base.transaction() do
        if @user.save
          redirect_to profile_user_path, flash: {success: t('message.success_completed')}
        else
          render 'profile'
        end
      end
    rescue => e
      logger.error(e.message)
      redirect_to root_path, flash: {alert: e.message}
    end
  end

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
      profile_attributes: [
      :id,
      :call_name,
      :kokuseki,
      :birthday,
      :sex,
      :injapan_flg,
      :address,
      :address_country,
      :visa_type,
      :visa_end_date,
      :desired_work_date,
      :jp_school_type,
      :jp_school_date,
      :jp_school_end,
      :jp_school_senko,
      :jp_school_name,
      :school_type,
      :school_date,
      :school_end,
      :school_senko,
      :school_name,
      :skill,
        profile_works_attributes: [
        :id,
        :work_country,
        :work_place,
        :work_type,
        :start_date,
        :end_date,
        :_destroy
        ],
        profile_languages_attributes: [
        :id,
        :native_lang,
        :jp_level,
        :use_lang,
        :use_lang_level,
        :_destroy
        ]
      ]
    )
  end
end
