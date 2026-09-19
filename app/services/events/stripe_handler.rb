module Events
  class StripeHandler
    def self.process(event)
      stripe_event = Stripe::Event.construct_from(event.data)
      Rails.logger.info("--------- Stripe Webhook Received #{ stripe_event.type }----------")
      case stripe_event.type
      when 'checkout.session.completed'
        checkout_session = stripe_event.data.object
        customer = Stripe::Customer.retrieve(checkout_session.customer)
        Rails.logger.info("Email customer #{ customer.email }")
        user = User.find_by(stripe_customer_id: checkout_session.customer)
        if user.present?
          user.update!(subscription_status: 'active', login_flg: true)
        else
#          user = User.find_by(email: customer.email)
#          if user.present?
#            user.update(stripe_customer_id: checkout_session.customer, subscription_status: 'active', login_flg: true)
#          else
#            deleted = Stripe::Customer.delete(checkout_session.customer)
#          end
          # {
          #   "id": "cus_NffrFeUfNV2Hib",
          #   "object": "customer",
          #   "deleted": true
          # }
        end
      when 'customer.subscription.created'
        subscription = stripe_event.data.object
        user = User.find_by(stripe_customer_id: subscription.customer)
        status = subscription.status
        user.update!(stripe_subscription_id: subscription.id, plan: subscription.items.data[0].price.lookup_key, subscription_status: subscription.status, login_flg: (status == 'active' || status == 'trialing')) if user.present?
        Rails.logger.info("customer.subscription.created "+user.email.to_s)
      when 'customer.subscription.updated', 'customer.subscription.deleted'
        subscription = stripe_event.data.object
        user = User.find_by(stripe_customer_id: subscription.customer)
        status = subscription.status
        user.update!(stripe_subscription_id: subscription.id, plan: subscription.items.data[0].price.lookup_key, subscription_status: subscription.status, login_flg: (status == 'active' || status == 'trialing')) if user.present?
      when 'customer.subscription.trial_will_end'
      when 'invoice.updated'
        invoice = stripe_event.data.object
        payment_url = invoice.hosted_invoice_url
        Rails.logger.info("invoice.updated "+payment_url.to_s)
      when 'invoice.finalized'
        invoice = stripe_event.data.object
        payment_url = invoice.hosted_invoice_url
        Rails.logger.info("invoice.finalized "+payment_url.to_s)
      when 'invoice.paid'
        # Continue to provision the subscription as payments continue to be made.
        # Store the status in your database and check when a user accesses your service.
        # This approach helps you avoid hitting rate limits.
      when 'invoice.payment_succeeded'
      when 'invoice.payment_failed'
        # The payment failed or the customer does not have a valid payment method.
        # The subscription becomes past_due. Notify your customer and send them to the
        # customer portal to update their payment information.
        # https://billing.stripe.com/p/login/3cI3cw4v27ht3KDbyHaMU00
      when 'customer.created'
        customer = stripe_event.data.object
        user = User.find_by(email: customer.email)
        Rails.logger.info("customer.created "+user.stripe_customer_id.to_s)
      when 'customer.updated'
        customer = stripe_event.data.object
        Rails.logger.info("customer.updated "+customer.id.to_s)
        user = User.find_by(stripe_customer_id: customer.id)
        if customer.address.present?
          user.update!(billing_address: customer.address)
          Stripe::Subscription.update(
            user.stripe_subscription_id,
            automatic_tax: { enabled: true }
          )
        end
      when 'customer.deleted'
        Rails.logger.info("customer.deleted "+stripe_event.data.object.id.to_s)
        user = User.find_by(stripe_customer_id: stripe_event.data.object.id)
        user.update!(billing_address: nil, plan: nil, stripe_customer_id: nil, login_flg: false) if user.present?
      end
    end
  end
end
