module BreadcrumbsConcern
  extend ActiveSupport::Concern
  include ActionView::Helpers::UrlHelper
  include Rails.application.routes.url_helpers

  included do
    before_action :set_breadcrumbs
  end

  private

  def add_breadcrumb(label, path = nil)
    @breadcrumbs ||= []
    @breadcrumbs << { label: label, path: path }
  end

  def set_breadcrumbs
    @breadcrumbs = []
    # Always add home as first breadcrumb
    add_breadcrumb(t('breadcrumbs.home'), root_path) unless current_page?(root_path)

    # Add controller name breadcrumb
    controller_key = controller_name.to_s
    add_breadcrumb(t("breadcrumbs.#{controller_key}"), url_for(action: :index))

    # Add action name breadcrumb if not index
    if action_name != 'index'
      add_breadcrumb(t("breadcrumbs.#{action_name}"))
    end
    if action_name != 'index'
      action_breadcrumb = t("breadcrumbs.#{action_name}", default: action_name.titleize)
      add_breadcrumb(action_breadcrumb)
    end
  end
end