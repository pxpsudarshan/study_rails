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
    avatar.attached? ? url_for(avatar.variant(resize_to_fit: [32, 32])) : url_for('thumb/missing.png')
  end

  def get_image(img)
    img.attached? ? url_for(img.variant(resize_to_fit: [500, 500])) : url_for('thumb/missing.png')
  end

  def embedded_svg filename, options={}
    file = File.read(Rails.root.join('app', 'assets', 'images', filename))
    doc = Nokogiri::HTML::DocumentFragment.parse file
    svg = doc.at_css 'svg'
    if options[:class].present?
      svg['class'] = options[:class]
    end
    doc.to_html.html_safe
  end

  def get_url(id, language)
    file_name = "#{id}_#{language}.mp3"
    file_path = Rails.root.join('public', 'audio', file_name)
    return "/audio/#{file_name}" if File.exist?(file_path)
    nil  # Return nil if the file doesn't exist
  end
  
  def get_lang_content(model, lang)
    return model.languages.where(language: lang).first if lang.present?
    model unless lang.present?
  end

  def get_media(model, lang = nil)
    media = get_lang_content(model, lang)
    media.mpg.attached? ? url_for(media.mpg) : nil if media.present?
  end

  def get_content(model, lang = nil)
    media = get_lang_content(model, lang)
    media.content if media.present?
  end

  def get_age(dob)
    now = Date.current
    years = now - dob.year.years
    months = now.month - dob.month
    years = years - 1.year if months < 0
    months = 11 + months if months < 0
    if now < dob
      result = '0歳'
    elsif months != 0
      result = years.year.to_s+'歳'+months.to_s+'ヵ月'
    else
      result = years.year.to_s+'歳'
    end
    result
  end

  def langs(code = nil)
    langs_hash = t('select.langs')
    langs_hash.present? ? code.present? ? [[langs_hash[code.to_sym], code]] : langs_hash.invert : []
  end

  def second_langs(code = nil)
    second_langs_hash = t('select.second_langs')
    second_langs_hash.present? ? code.present? ? [[second_langs_hash[code], code]] : second_langs_hash.invert : []
  end

  def get_access(type)
    case type
    when Comp::ACCESS_TYPE::KANRIGAISHA
      t('common.kanrisha')
    when Comp::ACCESS_TYPE::PARTNER
      t('common.partner')
    when Comp::ACCESS_TYPE::OTHER
      t('common.other')
    end
  end

  def get_user_access(type)
    case type
    when User::ACCESS_TYPE::KANRISHA
      t('common.kanrisha')
    when User::ACCESS_TYPE::POWER_USER
      t('common.power_user')
    when User::ACCESS_TYPE::USER
      t('common.user')
    end
  end

  def occupation_array(id = 0)
    occupation_hash = t('select.occupations')
    occupation_hash.present? ? id == 0 ? occupation_hash.invert : occupation_hash[id] : []
  end

  def industry_array(id = 0)
    industry_hash = t('select.industries')
    industry_hash.present? ? id == 0 ? industry_hash.invert : industry_hash[id] : []
  end

  def work_country_array(id = 0)
    work_country_hash = t('select.work_country')
    work_country_hash.present? ? id == 0 ? work_country_hash.invert : work_country_hash[id] : []
  end  

  def kokuseki_array(id = 0)
    kokuseki_hash = t('select.kokusekis')
    kokuseki_hash.present? ? id == 0 ? kokuseki_hash.invert : kokuseki_hash[id] : []
  end

  def visa_type_array(id = 0)
    visa_type_hash = t('select.visa_type')
    visa_type_hash.present? ? id == 0 ? visa_type_hash.invert : visa_type_hash[id] : []
  end    

  def sex_array(id = 0)
    sex_hash = t('select.sex')
    sex_hash.present? ? id == 0 ? sex_hash.invert : sex_hash[id] : []
  end

  def school_type_array(id = 0)
    school_type_hash = t('select.school_type')
    school_type_hash.present? ? id == 0 ? school_type_hash.invert : school_type_hash[id] : []
  end

  def school_end_array(id = 0)
    school_end_hash = t('select.school_end')
    school_end_hash.present? ? id == 0 ? school_end_hash.invert : school_end_hash[id] : []
  end

  def language_level(id = 0)
    language_level_hash = t('select.language_level')
    language_level_hash.present? ? id == 0 ? language_level_hash.invert : language_level_hash[id] : []
  end

  def pref_array(id = 0)
    arr = []
    prefecture_hash = t('select.prefectures')

    prefs = prefecture_hash.invert
    prefs.each do |element|
      text, value = option_text_and_value(element)
      arr << text if id.include?(value)
    end if id != 0
    id == 0 ? prefs : arr.join(', ')
  end

  def strict_decode64(str)
    decoded_str = str.force_encoding('UTF-8').unpack1("m0")
    decoded_str.force_encoding('UTF-8')
  end

  def src_nation(data)
    out = data.src_eng
    if data.src_nation.present?
      out = data.src_nation[current_user.lang_id] if data.src_nation[current_user.lang_id].present?
    end
    out
  end

  def title_nation(data)
    out = data.title_nation
    if current_user.lang_id.present? && current_user.lang_id != 'JP'
      out = data.languages.where(language: current_user.lang_id).first.content if data.languages.where(language: current_user.lang_id).present?
    end
    out
  end

  def content_nation(data)
    out = data.content
    if current_user.lang_id.present? && current_user.lang_id != 'JP'
      out = data.languages.where(language: current_user.lang_id).first.content if data.languages.where(language: current_user.lang_id).present?
    end
    out
  end

  def question_nation(data)
    out = get_content(data, 'EN')
    if data.languages.where(language: current_user.lang_id).present?
      out = get_content(data, current_user.lang_id)
    end
    out
  end

  def explain_nation(data)
    out = get_content(data, 'EN')
    if data.languages.where(language: current_user.lang_id).present?
      out = get_content(data, current_user.lang_id)
    end
    out
  end

  def string_to_array(text)
    return [] if text.nil?
    text.split(',').map(&:strip) # Splitting by comma and removing extra spaces
  end

end
