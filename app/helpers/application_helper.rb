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
end
