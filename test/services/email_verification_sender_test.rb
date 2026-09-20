require 'logger'
require 'active_support/all'
require 'securerandom'
require 'minitest/autorun'
require_relative '../../app/services/email_verification_sender'

class EmailVerificationSenderTest < Minitest::Test
  class Account
    attr_accessor :email_verify_flg, :email_verification_sent_at, :token, :email

    def name; 'Test User'; end
    def initialize; @email = 'learner@example.com'; end
    def assign_attributes(attributes)
      @original_email = email
      attributes.each { |key, value| public_send("#{key}=", value) }
    end
    def email_changed?; email != @original_email; end
    def save!; raise ArgumentError, 'Invalid email' if email.blank?; end
    def with_lock; yield; end
    def update!(attributes)
      attributes.each { |key, value| public_send("#{key}=", value) }
    end
  end

  class Mailer
    attr_reader :messages
    attr_accessor :fail_delivery

    def initialize; @messages = []; end
    def verify_email(*arguments)
      @arguments = arguments
      self
    end
    def deliver_now
      raise IOError, 'Delivery unavailable' if fail_delivery
      @messages << @arguments
    end
  end

  def setup
    @user = Account.new
    @mailer = Mailer.new
  end

  def send_email(attributes = {})
    EmailVerificationSender.call(@user, attributes: attributes, mailer: @mailer)
  end

  def test_sends_to_registered_address_and_creates_token
    assert_equal :sent, send_email
    refute_nil @user.token
    assert_equal [[@user.name, @user.email, @user.token]], @mailer.messages
    refute_nil @user.email_verification_sent_at
  end

  def test_resend_preserves_original_verification_link
    @user.token = 'original-token'
    @user.email_verification_sent_at = 61.seconds.ago
    assert_equal :sent, send_email
    assert_equal 'original-token', @mailer.messages.first.last
  end

  def test_repeated_requests_are_throttled
    assert_equal :sent, send_email
    assert_equal :throttled, send_email
    assert_equal 1, @mailer.messages.size
  end

  def test_verified_users_do_not_receive_email
    @user.email_verify_flg = true
    assert_equal :verified, send_email
    assert_empty @mailer.messages
  end

  def test_delivery_failure_does_not_start_cooldown_and_can_be_retried
    @mailer.fail_delivery = true
    assert_raises(IOError) { send_email }
    assert_nil @user.email_verification_sent_at
    @mailer.fail_delivery = false
    assert_equal :sent, send_email
    assert_equal 1, @mailer.messages.size
  end
  def test_changing_address_replaces_old_token_and_sends_to_new_address
    @user.token = 'old-token'
    assert_equal :sent, send_email(email: 'new@example.com')
    refute_equal 'old-token', @user.token
    assert_equal ['Test User', 'new@example.com', @user.token], @mailer.messages.first
  end

  def test_same_address_keeps_original_link
    @user.token = 'old-token'
    assert_equal :sent, send_email(email: @user.email)
    assert_equal 'old-token', @user.token
  end

  def test_cooldown_prevents_address_changes
    @user.email_verification_sent_at = Time.current
    assert_equal :throttled, send_email(email: 'new@example.com')
    assert_equal 'learner@example.com', @user.email
    assert_empty @mailer.messages
  end

  def test_verified_account_cannot_change_address
    @user.email_verify_flg = true
    assert_equal :verified, send_email(email: 'new@example.com')
    assert_equal 'learner@example.com', @user.email
    assert_empty @mailer.messages
  end

  def test_invalid_address_is_not_sent
    assert_raises(ArgumentError) { send_email(email: '') }
    assert_empty @mailer.messages
    assert_nil @user.email_verification_sent_at
  end

end
