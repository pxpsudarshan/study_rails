# frozen_string_literal: true

require "test_helper"

class MobileFuTest < ActionDispatch::IntegrationTest
  DESKTOP_UA = "Mozilla/5.0 (Macintosh; Intel Mac OS X 14_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.0 Safari/605.1.15"
  IPHONE_UA  = "Mozilla/5.0 (iPhone; CPU iPhone OS 18_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.0 Mobile/15E148 Safari/604.1"
  ANDROID_UA = "Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Mobile Safari/537.36"
  IPAD_UA    = "Mozilla/5.0 (iPad; CPU OS 18_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.0 Mobile/15E148 Safari/604.1"

  test "detects desktop browser and keeps html format" do
    get new_user_session_path, headers: { "HTTP_USER_AGENT" => DESKTOP_UA }

    assert_response :success
    assert_equal :html, request.format.to_sym
    assert_nil request.headers["X_MOBILE_DEVICE"]
    assert_not controller.is_mobile_device?
    assert_not controller.is_tablet_device?
  end

  test "detects iphone and sets mobile format" do
    get new_user_session_path, headers: { "HTTP_USER_AGENT" => IPHONE_UA }

    assert_response :success
    assert_equal "iphone", controller.mobile_device
    assert_equal :mobile, request.format.to_sym
    assert controller.is_mobile_device?
    assert_not controller.is_tablet_device?
  end

  test "detects android mobile phone and sets mobile format" do
    get new_user_session_path, headers: { "HTTP_USER_AGENT" => ANDROID_UA }

    assert_response :success
    assert_equal "android", controller.mobile_device
    assert_equal :mobile, request.format.to_sym
    assert controller.is_mobile_device?
  end

  test "detects ipad as tablet rather than mobile phone" do
    get new_user_session_path, headers: { "HTTP_USER_AGENT" => IPAD_UA }

    assert_response :success
    assert_equal :html, request.format.to_sym
    assert controller.is_tablet_device?
    assert_not controller.is_mobile_device?

#    assert_response :success
#    assert_equal :tablet, request.format.to_sym
#    assert controller.is_tablet_device?
#    assert_not controller.is_mobile_device?
  end

  test "safely handles abnormally long user agent without ReDoS" do
    malicious_ua = "Mozilla/5.0 " + ("android " * 5000)

    assert_nothing_raised do
      get new_user_session_path, headers: { "HTTP_USER_AGENT" => malicious_ua }
    end

    assert_response :success
  end
end
