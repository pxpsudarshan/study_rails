class UsersController < ApplicationController
  before_action :parent, except: [:verify_email, :resend_verification_email]
  skip_before_action :check_email, only: [:resend_verification_email]
  skip_before_action :authenticate_users, only: [:verify_email]

  def verify_email
    redirect_to menus_path and return if current_user.present? && current_user.email_verify_flg
    user = User.where(token: params[:api_token]).first if params[:api_token].present?
    if params[:api_token].present? && user.present?
      user.update!(email_verify_flg: true, token: nil)
      sign_out user
      redirect_to menus_path and return
    end
    render :verify_email, layout: 'verify_email'
  end

  def resend_verification_email
    result = EmailVerificationSender.call(current_user)
    if result == :verified
      redirect_to menus_path
    else
      key = result == :sent ? :success : :warning
      message = result == :sent ? 'email_verification.resent' : 'email_verification.cooldown'
      redirect_to verify_email_users_path, flash: { key => t(message) }
    end
  rescue StandardError => e
    Rails.logger.error("Verification email delivery failed: #{e.class}")
    redirect_to verify_email_users_path, alert: t('email_verification.send_failed')
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
          redirect_to menus_path, flash: {success: t('message.success_completed')}
        else
          render 'edit'
        end
      end
    rescue => e
      logger.error(e.message)
      redirect_to menus_path, flash: {alert: e.message}
    end
  end

  def profile
    if @user.profile.blank?
      @user.build_profile
    end

    render 'profile'
  end

  def update_profile
    @user.assign_attributes(user_params)
    begin
      ActiveRecord::Base.transaction do
        if @user.save
          redirect_to profile_user_path, flash: { success: t('message.success_completed') }
        else
          render 'profile'
        end
      end
    rescue => e
      logger.error(e.message)
      redirect_to menus_path, flash: {alert: e.message}
    end
  end

  private

  def parent
    @user = User.find(params[:id]) if params[:id].present?
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
      :plan,
      profile_attributes: [
      :id,
      :photo,
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
      :desired_job_type,
      :desired_industry,
      :desired_work_place,
      :japanese_level,
      :english_level,
      :toeic_score,
      :native_language,
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
