# frozen_string_literal: true

require "mobile_fu/mobile_detect"
require "mobile_fu/tablet"
require "rails"

module MobileFu
  autoload :Helper, "mobile_fu/helper"

  class Railtie < Rails::Railtie
    initializer "mobile-fu.configure" do |app|
      app.config.middleware.use MobileFu::MobileDetect
    end

    initializer "mobile-fu.action_controller" do
      ActiveSupport.on_load(:action_controller) do
        include ActionController::MobileFu
      end
    end

    initializer "mobile-fu.action_view" do
      ActiveSupport.on_load(:action_view) do
        prepend MobileFu::Helper
      end
    end

    Mime::Type.register_alias "text/html", :mobile
    Mime::Type.register_alias "text/html", :tablet
  end
end

module ActionController
  module MobileFu
    extend ActiveSupport::Concern

    included do
      class_attribute :mobile_exempt_actions, instance_writer: false
      class_attribute :mobile_include_actions, instance_writer: false
    end

    class_methods do
      def has_mobile_fu(set_request_format = true)
        include ActionController::MobileFu::InstanceMethods

        before_action :set_request_format if set_request_format

        helper_method :is_mobile_device?
        helper_method :is_tablet_device?
        helper_method :in_mobile_view?
        helper_method :in_tablet_view?
        helper_method :is_device?
        helper_method :mobile_device
      end

      def has_no_mobile_fu_for(*actions)
        self.mobile_exempt_actions = actions.map(&:to_sym)
      end

      def has_mobile_fu_for(*actions)
        self.mobile_include_actions = actions.map(&:to_sym)
      end
    end

    module InstanceMethods
      def set_request_format(force_mobile = false)
        force_mobile ? force_mobile_format : set_mobile_format
      end
      alias set_device_type set_request_format

      def force_mobile_format
        return if request.xhr?

        request.format = :mobile
        session[:mobile_view] = true if session[:mobile_view].nil?
      end

      def force_tablet_format
        return if request.xhr?

        request.format = :tablet
        session[:tablet_view] = true if session[:tablet_view].nil?
      end

      def set_mobile_format
        return unless request.format
        return unless request.format.html? && mobile_action? && !request.xhr?

        if is_mobile_device?
          request.format = :mobile unless session[:mobile_view] == false
          session[:mobile_view] = true if session[:mobile_view].nil?
        elsif is_tablet_device?
          request.format = :tablet unless session[:tablet_view] == false
          session[:tablet_view] = true if session[:tablet_view].nil?
        end
      end

      def in_mobile_view?
        request.format&.to_sym == :mobile
      end

      def in_tablet_view?
        request.format&.to_sym == :tablet
      end

      def is_tablet_device?
        ::MobileFu::Tablet.is_a_tablet_device?(request.user_agent)
      end

      def is_mobile_device?
        !is_tablet_device? && mobile_device.present?
      end

      def mobile_device
        request.env["HTTP_X_MOBILE_DEVICE"] || request.headers["X-Mobile-Device"]
      end

      def is_device?(type)
        request.user_agent.to_s.downcase.include?(type.to_s.downcase)
      end

      def mobile_action?
        if mobile_include_actions.nil?
          !mobile_exempt?
        else
          mobile_include_actions.include?(params[:action]&.to_sym)
        end
      end

      def mobile_exempt?
        mobile_exempt_actions&.include?(params[:action]&.to_sym) || false
      end
    end
  end
end
