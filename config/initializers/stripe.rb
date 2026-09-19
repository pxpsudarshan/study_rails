credentials = Rails.application.credentials
sk_secret = Rails.env.development? ? credentials.dig(:stripe_test, :sk) : credentials.dig(:stripe, :sk)
Stripe.api_key = sk_secret
