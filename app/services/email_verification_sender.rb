class EmailVerificationSender
  COOLDOWN = 60.seconds

  def self.call(user, attributes: {}, mailer: UserMailer)
    user.with_lock do
      return :verified if user.email_verify_flg
      return :throttled if user.email_verification_sent_at.present? && user.email_verification_sent_at > COOLDOWN.ago

      user.assign_attributes(attributes)
      # Only changing the address invalidates an existing verification link.
      user.token = SecureRandom.uuid if user.email_changed? || user.token.blank?
      user.save!
      mailer.verify_email(user.name, user.email, user.token).deliver_now
      user.update!(email_verification_sent_at: Time.current)
      :sent
    end
  end
end
