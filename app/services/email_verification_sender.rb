class EmailVerificationSender
  COOLDOWN = 60.seconds

  def self.call(user, mailer: UserMailer)
    user.with_lock do
      return :verified if user.email_verify_flg
      return :throttled if user.email_verification_sent_at.present? && user.email_verification_sent_at > COOLDOWN.ago

      # Keep existing links valid when the original email arrives late.
      user.update!(token: user.token.presence || SecureRandom.uuid)
      mailer.verify_email(user.name, user.email, user.token).deliver_now
      user.update!(email_verification_sent_at: Time.current)
      :sent
    end
  end
end
