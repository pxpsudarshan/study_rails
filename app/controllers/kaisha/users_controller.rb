class Kaisha::UsersController < ApplicationController
  skip_before_action :authenticate_users, only: [:new_user, :create]
  before_action :parent, except: [:index, :new, :create, :new_user]

  def index
    @users = User.order(access_type: :desc).order(:sei, :mei)
    @users = User.where(comp_id: current_comp.id).order(access_type: :desc).order(:sei, :mei) if current_comp.access_type == Comp::ACCESS_TYPE::OTHER
    @users = User.joins(:comp).where(comp_id: current_comp.id).or(User.joins(:comp).where(comps: {comp_id: current_comp.id})).order(access_type: :desc).order(:sei, :mei) if current_comp.access_type == Comp::ACCESS_TYPE::PARTNER
    #@users = @users.where(userid: params[:search][:userid]) if params[:search].present? && params[:search][:userid].present?
    @users = @users.page(params[:page]).per(params[:per])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    @user = User.new if current_comp.access_type == Comp::ACCESS_TYPE::KANRIGAISHA
    @user = User.new(comp_id: current_comp.id) if current_comp.access_type != Comp::ACCESS_TYPE::KANRIGAISHA
  end

  def show
  end

  def edit
  end

  def update
    @user.assign_attributes(user_params)
    begin
      ActiveRecord::Base.transaction() do
        delete_stripe_subscription(@user) if @user.comp_id.present? && @user.stripe_subscription_id.present?
        if @user.comp_id.present? && @user.subscription_status == 'canceled'
          @user.stripe_subscription_id = nil
          @user.subscription_status = 'incomplete'
          Stripe::Customer.delete(@user.stripe_customer_id)
        end
        if @user.save
          redirect_to kaisha_users_path, flash: {success: t('message.success_completed')}
        else
          render 'edit'
        end
      end
    rescue => e
      logger.error(e.message)
      redirect_to kaisha_users_path, flash: {alert: e.message}
    end
  end

  def create
    @user = User.new(user_params)
    @user.mycard_sign = true
    @user.entry_no = Time.current.to_i
    @user.trial_end_date = Date.current+30.day
    begin
      ActiveRecord::Base.transaction() do
        if @user.save
          if @user.comp_id.present? && current_comp.blank?
            redirect_to root_path, flash: {success: t('message.success_completed')}
          else
            redirect_to kaisha_users_path, flash: {success: t('message.success_completed')}
          end
        else
          render 'new'
        end
      end
    rescue => e
      logger.error(e.message)
      redirect_to kaisha_users_path, flash: {alert: e.message}
    end
  end

  def destroy
    begin
      ActiveRecord::Base.transaction() do
        Stripe::Customer.delete(@user.stripe_customer_id) if @user.stripe_customer_id.present?
        @user.destroy!
        redirect_to kaisha_users_path
      end
    rescue => e
      logger.error(e.message)
      redirect_to kaisha_users_path, flash: {alert: e.message}
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
          redirect_to kaisha_profile_user_path, flash: {success: t('message.success_completed')}
        else
          render 'profile'
        end
      end
    rescue => e
      logger.error(e.message)
      redirect_to root_path, flash: {alert: e.message}
    end
  end

  def new_user
    comp_id = params[:id]
    @user = User.new(comp_id: comp_id)
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
      :comp_id,
      :login_flg,
      :trial_end_date,
      :access_type,
      :plan,
      profile_attributes: [
      :id,
      :name_kana,
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
        ],
        profile_qualifications_attributes: [
          :id,
          :achieved_year,
          :achieved_month,
          :qualification_name,
          :_destroy
        ]
      ]
    )
  end
end
