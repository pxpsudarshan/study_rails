module BootstrapFlashHelper
  ALERT_TYPES = [:danger, :info, :success, :warning]

  def bootstrap_flash
    flash_messages = []
    flash.each do |type, message|
      # Skip empty messages, e.g. for devise messages set to nothing in a locale file.
      next if message.blank?

      type = :success if type == "notice"
      type = :danger  if type == "alert"
      type = :danger  if type == "recaptcha_error"
      type = :success if type == "success"
      type = :info if type == "info"
      type = :warning if type == "warning"
      next unless ALERT_TYPES.include?(type)
      Array(message).each do |msg|
        text = content_tag(:div, content_tag(:button, '', class: "btn-close", aria: { label: "Close" }, data: { "bs-dismiss": "alert" }) +
          msg.html_safe, class: "alert alert-#{type} alert-dismissible fade show", role: 'alert')
        flash_messages << text if message
      end
    end
    flash_messages.join("\n").html_safe
  end
end
