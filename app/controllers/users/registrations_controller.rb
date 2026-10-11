# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]

  def create
    return review_registration if params[:registration_token].blank?

    @confirmed_attributes = registration_encryptor.decrypt_and_verify(
      params[:registration_token], purpose: 'user_registration'
    )
    return restart_registration unless @confirmed_attributes

    if params[:edit].present?
      build_resource(sign_up_params)
      clean_up_passwords resource
      flash.now[:notice] = t('users.registrations.confirm.reenter_password')
      render :new
    else
      super
    end
  rescue ActiveSupport::MessageEncryptor::InvalidMessage, ActiveSupport::MessageVerifier::InvalidSignature
    restart_registration
  end

  protected

  def build_resource(attributes = {})
    super
    resource.mycard_sign = true
    resource.entry_no = Time.current.to_i
  end

  def sign_up_params
    @confirmed_attributes || super
  end

  # Send verification only after the confirmed registration has been saved.
  def after_sign_up_path_for(resource)
    begin
      EmailVerificationSender.call(resource)
      flash[:notice] = t('email_verification.resent')
    rescue StandardError => e
      Rails.logger.error("Registration verification email failed: #{e.class}")
      flash.delete(:notice)
      flash[:alert] = t('email_verification.send_failed')
    end
    verify_email_users_path
  end

  private

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:sei, :mei, :lang_id])
  end

  def review_registration
    build_resource(sign_up_params)
    if resource.valid?
      @registration_token = registration_encryptor.encrypt_and_sign(
        sign_up_params.to_h, purpose: 'user_registration', expires_in: 20.minutes
      )
      render :confirm
    else
      clean_up_passwords resource
      render :new, status: :unprocessable_entity
    end
  end

  def restart_registration
    redirect_to new_user_registration_path, alert: t('users.registrations.confirm.expired')
  end

  def registration_encryptor
    key = Rails.application.key_generator.generate_key('user_registration', 32)
    ActiveSupport::MessageEncryptor.new(key, cipher: 'aes-256-gcm')
  end
end
