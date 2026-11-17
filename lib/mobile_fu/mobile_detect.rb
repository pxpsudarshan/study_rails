# frozen_string_literal: true

module MobileFu
  class MobileDetect
    MOBILE_DEVICES = {
      iphone: /iphone|ipod/i,
      android: /android.*mobile/i,
      windows_phone: /windows phone|iemobile|wpdesktop/i,
      blackberry: /blackberry|bb10|rim/i,
      opera_mini: /opera mini|opera mobi/i,
      mobile_other: /mobile|webos|symbian|palm|nokia|samsung|sonyericsson|motorola|lg-|htc|huawei|xiaomi|redmi|poco|realme|oppo|vivo/i
    }.freeze

    def initialize(app)
      @app = app
    end

    def call(env)
      user_agent = env["HTTP_USER_AGENT"]
      if user_agent.present?
        detected = detect_device(user_agent)
        env["HTTP_X_MOBILE_DEVICE"] = detected if detected
      end

      @app.call(env)
    end

    private

    def detect_device(user_agent)
      # Защита от ReDoS при аномально длинном заголовке User-Agent
      safe_ua = user_agent.to_s.byteslice(0, 1024)

      MOBILE_DEVICES.each do |name, regex|
        return name.to_s if regex.match?(safe_ua)
      end

      nil
    end
  end
end
