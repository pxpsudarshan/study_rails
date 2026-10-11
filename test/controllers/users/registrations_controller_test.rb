require 'test_helper'
require 'minitest/mock'

class Users::RegistrationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @attributes = {
      sei: 'Test', mei: 'Student', email: 'registration-flow@example.test', lang_id: 'EN',
      password: 'ReviewPass123', password_confirmation: 'ReviewPass123'
    }
    @previous_url_options = ActionMailer::Base.default_url_options
    ActionMailer::Base.default_url_options = { host: 'example.test' }
    ActionMailer::Base.deliveries.clear
  end

  teardown do
    ActionMailer::Base.default_url_options = @previous_url_options
  end

  test 'review validates details without registering or sending email' do
    assert_no_difference ['User.count', 'ActionMailer::Base.deliveries.size'] do
      post user_registration_path, params: { user: @attributes }
    end

    assert_response :success
    assert_select 'h1', I18n.t('users.registrations.confirm.title')
    assert_select '.registration-actions > button:first-child', I18n.t('users.registrations.confirm.edit')
    assert_select '.registration-actions > button:last-child', I18n.t('users.registrations.confirm.send_email')
    assert_select 'dd', @attributes[:email]
    assert_select 'input[name="registration_token"]', 1
    assert_select 'input[type="password"]', 0
    refute_includes response.body, @attributes[:password]
  end

  test 'invalid details stay on the input screen' do
    assert_no_difference ['User.count', 'ActionMailer::Base.deliveries.size'] do
      post user_registration_path, params: { user: @attributes.merge(password_confirmation: 'Mismatch123') }
    end

    assert_response :unprocessable_entity
    assert_select '.alert-danger'
    assert_select 'input[name="user[email]"][value=?]', @attributes[:email]
    assert_select 'input[name="registration_token"]', 0
  end

  test 'editing restores details without registering' do
    token = review_token
    assert_no_difference ['User.count', 'ActionMailer::Base.deliveries.size'] do
      post user_registration_path, params: { registration_token: token, edit: '1' }
    end

    assert_response :success
    assert_select 'input[name="user[sei]"][value=?]', @attributes[:sei]
    assert_select 'input[name="user[email]"][value=?]', @attributes[:email]
    assert_select 'input[name="user[password]"][value]', 0
  end

  test 'confirmation registers reviewed details and sends verification email' do
    token = review_token
    assert_difference ['User.count', 'ActionMailer::Base.deliveries.size'], 1 do
      post user_registration_path, params: { registration_token: token, user: { email: 'changed@example.test' } }
    end

    assert_redirected_to verify_email_users_path
    user = User.find_by!(email: @attributes[:email])
    assert user.valid_password?(@attributes[:password])
    assert user.mycard_sign
    assert_operator user.entry_no, :>, 0
    assert_not user.email_verify_flg
    assert user.token.present?
    assert user.email_verification_sent_at.present?
    assert_equal [@attributes[:email]], ActionMailer::Base.deliveries.last.to
    assert_equal ['no-reply@ni-ho.com'], ActionMailer::Base.deliveries.last.from

    follow_redirect!
    assert_response :success
    assert_select 'strong', @attributes[:email]
    assert_select 'p', I18n.t('email_verification.sender_notice', sender: UserMailer::VERIFICATION_SENDER)
  end

  test 'tampered confirmation cannot register' do
    token = review_token
    assert_no_difference ['User.count', 'ActionMailer::Base.deliveries.size'] do
      post user_registration_path, params: { registration_token: "#{token}invalid" }
    end
    assert_redirected_to new_user_registration_path
  end

  test 'expired confirmation cannot register' do
    token = review_token
    travel 21.minutes do
      assert_no_difference ['User.count', 'ActionMailer::Base.deliveries.size'] do
        post user_registration_path, params: { registration_token: token }
      end
    end
    assert_redirected_to new_user_registration_path
  end

  test 'email taken after review is revalidated on confirmation' do
    token = review_token
    User.create!(@attributes)
    assert_no_difference ['User.count', 'ActionMailer::Base.deliveries.size'] do
      post user_registration_path, params: { registration_token: token }
    end
    assert_select '.alert-danger'
    assert_select 'input[name="user[email]"]'
  end

  test 'delivery failure still reaches the verification page with the delivery error' do
    token = review_token
    EmailVerificationSender.stub :call, ->(*) { raise IOError, 'Delivery unavailable' } do
      assert_difference 'User.count', 1 do
        post user_registration_path, params: { registration_token: token }
      end
    end
    assert_redirected_to verify_email_users_path
    assert_equal I18n.t('email_verification.send_failed'), flash[:alert]
    follow_redirect!
    assert_response :success
    assert_select '.alert', text: /#{Regexp.escape(I18n.t('email_verification.send_failed'))}/
  end

  private

  def review_token
    post user_registration_path, params: { user: @attributes }
    assert_response :success
    Nokogiri::HTML(response.body).at_css('input[name="registration_token"]')['value']
  end
end
