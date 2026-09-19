class WebhookEventsController < ApplicationController
  # ignore csrf
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_users, only: [:create]

  # v0: process events
  # v1: save, process events
  # v2: verify signatures, save, process
  # v3: verify signatures, save, enqueue and process later
  def create
    # verify signatures
    # - check requester's IP address against known Stripe IPs
    # - use basic auth
    #    - https://uzer:pa$$@myapp.com/webhook_events/stripe
    # - retrieve event when notified
    #   - Stripe::Event.retrieve("evt_xxx")
    if !signatures_valid?
      render json: {message: "signature invalid"}, status: 400
      return
    end

    # check if already handled
    if !WebhookEvent.find_by(external_id: external_id, source: params[:source]).nil?
      render json: {}
      return
    end

    # save it
    event = WebhookEvent.create!(webhook_params)
#    credentials = Rails.application.credentials
#    sk_secret = Rails.env.development? ? credentials.dig(:stripe_test, :sk) : credentials.dig(:stripe, :sk)
#    Stripe.api_key = sk_secret

    # and process
    ProcessEventsJob.perform_later(event.id)
    #event = WebhookEvent.find(event.id)
    #if event.source == 'stripe'
    #  Events::StripeHandler.process(event)
    #end

    render json: { message: 'success' }
  end

  def signatures_valid?
    if params[:source] == 'stripe'
      begin
        credentials = Rails.application.credentials
        wh_secret = Rails.env.development? ? credentials.dig(:stripe_test, :wh) : credentials.dig(:stripe, :wh)
        Stripe::Webhook.construct_event(
          request.body.read,
          request.env['HTTP_STRIPE_SIGNATURE'],
          wh_secret
        )
      rescue Stripe::SignatureVerificationError => e
        return false
      end
    end

    true
  end

  def webhook_params
    {
      source: params[:source],
      data: params.except(:source, :controller, :action).permit!,
      external_id: external_id
    }
  end

  def external_id
    return params[:id] if params[:source] == 'stripe'
    SecureRandom.hex
  end
end
