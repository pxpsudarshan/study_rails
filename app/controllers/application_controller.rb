class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_response_headers, except: [ ]
  before_action :check_ip
  before_action :authenticate_users
  before_action :force_tablet_html
#  has_mobile_fu
  before_action do
    RecordWithOperator.operator = current_user.present? ? current_user : current_comp.present? ? current_comp : User.first
  end
  before_action :require_payment
  before_action :require_subscription!
  before_action :set_locales, except: [ ]
  before_action :check_email

  def authenticate_users
    if controller_path.split('/').first.to_s == 'kaisha'
      authenticate_comp!
    else
      authenticate_user!
    end
  end

  def force_tablet_html
      session[:tablet_view] = false
  end

  def set_response_headers
    response.headers['Pragma']        = 'no-cache'
    response.headers['Cache-Control'] = 'no-store'
    response.headers['Expires']       = 'Thu, 01 Dec 1994 16:00:00 GMT'
  end

  def set_locale(value)
    session[:locale] = value if value.present?
    session[:locale] ||= 'ja'
    @locale = session[:locale]
    I18n.locale = @locale
  end

  def set_locales
    @locale = params[:locale] # || 'ja' #configuration('default_locale')
    set_locale(@locale) # if @locale
    @locales = [
      ["Japanese", 'ja'],
      ["English",  'en']
    ]
  end

  def check_ip
    ip = request.remote_ip
    bip = BlockIp.where(ipaddr: ip)
    if bip.exists?
      render file: "#{Rails.root}/public/404.html", status: :not_found, layout: false and return
    end
  end

  def vocab_cards(vocab_code)
    #関連する語彙
    vocab_code_kanji = vocab_code.scan(/\p{Han}/).join
    cards = []
    if vocab_code_kanji.present?
      cards = VocabTable
      .joins(:vocab_mycards)
      .where(vocab_mycards: { user_id: current_user.id })
      .where('vocab_tables.vocab_code ~* ?', "[#{vocab_code_kanji}]")
      .where.not(vocab_code: vocab_code)
    end
    cards
  end

  def require_subscription!
    if current_user.present? && (current_user.subscription_status == 'canceled' || current_user.subscription_status == 'past_due')
      sign_out User.find(current_user.id)
      redirect_to root_path
    end
  end

  def require_payment
    if current_user.present? && current_user.comp.present? &&
       current_user.trial_end_date.present? && current_user.trial_end_date < Date.current
      sign_out User.find(current_user.id)
      redirect_to root_path #, flash: { alert: t('message.trial_ended') }
    end
  end

  def check_email
    if current_user.present? && !current_user.email_verify_flg && action_name != 'verify_email'
      EmailVerificationSender.call(current_user) if current_user.token.blank?
      redirect_to verify_email_users_path, notice: t('email_verification.resent')
    end
  end

  def create_stripe_customer(user)
    customer = Stripe::Customer.create(
      email: user.email,
      name: user.name,
      phone: user.mobile,
#      metadata: {
#        selected_plan: user.plan
#      }
    )
    customer
  end

  def create_stripe_subscription(user)
    plan = user.plan.blank? ? ['kanrin'] : [user.plan]
    price = Stripe::Price.list(lookup_keys: plan).data.first
    if price.blank?
      Syslog.create!(occurred_at: Time.current, context: "No price detected from plan #{plan.first}.", log_type: 'エラー')
      raise "No price detected from plan #{plan.first}."
    end
    user.update!(plan: plan.first) if user.plan.blank?
    subscription = Stripe::Subscription.create({
      customer: user.stripe_customer_id,
      items: [{price: price.id}],
      trial_end: (Time.current+30.day).to_i
    })
    Syslog.create!(occurred_at: Time.current, context: "Subscription was created for #{user.plan} and #{user.email}.", log_type: 'Info')
    subscription
  end

  def update_stripe_subscription(user)
    begin
      price = Stripe::Price.list(lookup_keys: [user.plan]).data.first
      subscriptions = Stripe::Subscription.list(
        customer: user.stripe_customer_id,
        price: price.id
      )
      subscription = Stripe::Subscription.update(
        subscriptions.data[0].id,
        trial_end: (Time.current+30.day).to_i
      )
      Syslog.create!(occurred_at: Time.current, context: "Subscription was updated for #{user.plan} and #{user.email}.", log_type: 'Info')
      subscription
    rescue Stripe::InvalidRequestError => e
      Syslog.create!(occurred_at: Time.current, context: e.message, log_type: 'エラー')
    end
  end

  def delete_stripe_subscription(user)
    begin
      price = Stripe::Price.list(lookup_keys: [user.plan]).data.first
      subscriptions = Stripe::Subscription.list(
        customer: user.stripe_customer_id,
        price: price.id
      )
      if subscriptions.data[0].present?
        Stripe::Subscription.cancel(
          subscriptions.data[0].id,
        )
        Syslog.create!(occurred_at: Time.current, context: "Subscription was canceled for #{user.plan} and #{user.email}.", log_type: 'Info')
      end
    rescue Stripe::InvalidRequestError => e
      Syslog.create!(occurred_at: Time.current, context: e.message, log_type: 'エラー')
    end
  end

  protected
#  def after_sign_out_path_for(resource_or_scope)
#  end

  def after_sign_in_path_for(resource)
    if current_user.present?
      sign_out Comp.find(current_comp.id) if current_comp.present?
      if current_user.comp_id.present? && current_user.subscription_status == 'canceled'
        current_user.update!(stripe_subscription_id: nil, subscription_status: 'incomplete')
        Stripe::Customer.delete(current_user.stripe_customer_id)
      end
      login_flg = current_user.login_flg
      unless login_flg
        sign_out User.find(current_user.id)
      else
        Syslog.create!(occurred_at: Time.current, context: "#{current_user.email}はログインしました。", log_type: 'アクセス')
      end
      if login_flg && current_user.email_verify_flg && current_user.comp_id.blank? && current_user.access_type == User::ACCESS_TYPE::USER # only b2c user
        if current_user.stripe_customer_id.blank?
          customer = create_stripe_customer(current_user)
          current_user.update!(stripe_customer_id: customer.id)
        end
        if current_user.stripe_customer_id.present?
          update_stripe_subscription(current_user) if current_user.stripe_subscription_id.blank? && current_user.plan.present?
          create_stripe_subscription(current_user) if current_user.plan.blank?
        end
      end
    end
    if current_comp.present?
      sign_out User.find(current_user.id) if current_user.present?
      login_flg = current_comp.login_flg
      unless login_flg
        sign_out Comp.find(current_comp.id)
      else
        Syslog.create!(occurred_at: Time.current, context: "#{current_comp.email}はログインしました。", log_type: 'アクセス')
      end
    end
    stored_location_for(resource) || (current_user.present? ? menus_path : kaisha_menus_path)
  end
end
