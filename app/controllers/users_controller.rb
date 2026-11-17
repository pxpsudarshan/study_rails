class UsersController < ApplicationController
  before_action :parent
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

  def back_to_login
    sign_out current_user if current_user.present?
    redirect_to menus_path
  end

  def subscription
    redirect_to menus_path and return if current_user.subscription_status == 'active'
    price = Stripe::Price.list(
            lookup_keys: ['kanrin', 'kanrin_usd', 'trip-arcade'],
            expand: ['data.product'],
            active: true
            ).data.first
    @user_price = "#{price.unit_amount} #{price.currency.upcase} / #{price.recurring.interval}" if price.present?
    @product_name = price.product.name

    if current_user.trial_end_date.present? && current_user.subscription_status == 'incomplete' && current_user.stripe_customer_id.blank?
      customer = create_stripe_customer(current_user)
      current_user.update!(stripe_customer_id: customer.id)
    elsif current_user.stripe_subscription_id.present?
      subscription = Stripe::Subscription.retrieve(current_user.stripe_subscription_id)
      @end_date = Time.zone.at(subscription.trial_end).strftime("%Y-%m-%d %H:%M:%S %Z") if subscription.trial_end.present?
      @canceled_at = Time.zone.at(subscription.canceled_at).strftime("%Y-%m-%d %H:%M:%S %Z") if subscription.canceled_at.present?
    end

    if current_user.subscription_status == 'canceled' || current_user.subscription_status == 'incomplete'
#      Stripe::Customer.update(current_user.stripe_customer_id,
#      { address: { country: current_user.lang_id } })

      price = Stripe::Price.list(lookup_keys: [current_user.plan]).data.first
      session = Stripe::Checkout::Session.create({
        customer: current_user.stripe_customer_id,
        mode: 'subscription',
        automatic_tax: { enabled: true }, 
        billing_address_collection: 'required',
        customer_update: {
          address: 'auto'
        },
        line_items: [{
          price: price.id,
          quantity: 1,
        }],
        success_url: Rails.env.development? ? 'https://study.kanrin.biz' : 'https://www.ni-ho.com', 
        cancel_url: Rails.env.development? ? 'https://study.kanrin.biz' : 'https://www.ni-ho.com', 
      })
      @payment_link = session.url
    end

    render :subscription, layout: 'devise'
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
