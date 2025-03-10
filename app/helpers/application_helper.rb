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

  def occupation_array(id = 0)
    id = id.to_i
    out = ''
    ocs = occupation_list
    ocs.each do |element|
      text, value = option_text_and_value(element)
      out = text if id == value
    end if id != 0
    id == 0 ? ocs : out

  end

  def country_array(id = 0)
    id = id.to_i
    out = ''
    countries = [
      ['日本',1],
      ['アメリカ',2]
    ]
    countries.each do |element|
      text, value = option_text_and_value(element)
      out = text if id == value
    end if id != 0
    id == 0 ? countries : out
  end

  def kokuseki_array(id = 0)
    out = ''
    kokusekis = [
      ['EN',1],
      ['JP',2],
      ['RU',3],
      ['CH',4]
    ]
    kokusekis.each do |element|
      text, value = option_text_and_value(element)
      out = text if id == value
    end if id != 0
    id == 0 ? kokusekis : out
  end

  def sex_array(id = 0)
    out = ''
    sexs = [
      ['男性', 1],
      ['女性', 2],
      ['答えたくない', 3]
    ]
    sexs.each do |element|
      text, value = option_text_and_value(element)
      out = text if id == value
    end if id != 0
    id == 0 ? sexs : out
  end

  def school_type_array(id = 0)
    out = ''
    types = [
      ['大学(博士)', 1],
      ['大学(修士)', 2],
      ['大学(学部)', 3],
      ['専門学校', 4],
      ['高校 卒業', 5]
    ]
    types.each do |element|
      text, value = option_text_and_value(element)
      out = text if id == value
    end if id != 0
    id == 0 ? types : out
  end

  def school_end_array(id = 0)
    out = ''
    ends = [
      ['卒業', 1],
      ['中退', 2],
      ['休学', 3],
      ['卒業予定', 4]
    ]
    ends.each do |element|
      text, value = option_text_and_value(element)
      out = text if id == value
    end if id != 0
    id == 0 ? ends : out
  end

  def pref_array(id = 0)
    arr = []
    prefs = [
      ['北海道', 1],
      ['青森県', 2],
      ['岩手県', 3],
      ['宮城県', 4],
      ['秋田県', 5],
      ['山形県', 6],
      ['福島県', 7],
      ['茨城県', 8],
      ['栃木県', 9],
      ['群馬県', 10],
      ['埼玉県', 11],
      ['千葉県', 12],
      ['東京都', 13],
      ['神奈川県', 14],
      ['新潟県', 15],
      ['富山県', 16 ],
      ['石川県', 17],
      ['福井県', 18],
      ['山梨県', 19],
      ['長野県', 20],
      ['岐阜県', 21],
      ['静岡県', 22],
      ['愛知県', 23],
      ['三重県', 24],
      ['滋賀県', 25],
      ['京都府', 26],
      ['大阪府', 27],
      ['兵庫県', 28],
      ['奈良県', 29],
      ['和歌山県', 30],
      ['鳥取県', 31],
      ['島根県', 32],
      ['岡山県', 33],
      ['広島県', 34],
      ['山口県', 35],
      ['徳島県', 36],
      ['香川県', 37],
      ['愛媛県', 38],
      ['高知県', 39],
      ['福岡県', 40],
      ['佐賀県', 41],
      ['長崎県', 42],
      ['熊本県', 43],
      ['大分県', 44],
      ['宮崎県', 45],
      ['鹿児島県', 46],
      ['沖縄県', 47],
      ['海外', 48]
    ]
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
