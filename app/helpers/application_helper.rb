module ApplicationHelper

  def path_to_current_javascript
    controller.class.to_s.gsub('::', '/').underscore.sub(/_controller$/, '')
  end

  def individual_javascript_include_tag
    javascript_include_tag(path_to_current_javascript, 'data-turbolinks-track': 'reload') unless controller_name == 'application'
  end

  def individual_mobile_javascript_include_tag
    javascript_include_tag('mobile/'+path_to_current_javascript, 'data-turbolinks-track': 'reload') unless controller_name == 'application'
  end

  def page_title
    t("page_title.#{controller_name}.#{action_name}")
  end

  def page_title_mobile
    t("page_title.mobile.#{controller_name}.#{action_name}")
  end

  def locales
    I18n.locale.to_s
  end

  def get_full_date(date)
    date.strftime('%-m朁Ed日')+'('+t(:"date.abbr_day_names")[date.wday]+')'
  end

  def get_YMD_date(date)
    date.strftime('%Y年%-m朁Ed日')+'('+t(:"date.abbr_day_names")[date.wday]+')'
  end

  def favicon_link_tag(source='/favicon.ico', options={})
    tag('link', {
      :rel => 'shortcut icon',
      :type => 'image/vnd.microsoft.icon',
      :href => path_to_image(source)
    }.merge(options.symbolize_keys))
  end

  def get_avatar(avatar)
    avatar.attached? ? url_for(avatar.variant(resize_to_fit: [32, 32])) : 'thumb/missing.png'
  end
end
