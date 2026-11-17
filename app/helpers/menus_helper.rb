module MenusHelper
  def menu_genre_title(genre)
    language = current_user&.lang_id
    translation = genre.languages.find { |item| item.language == language } unless language.blank? || language == 'JP'
    strip_tags(translation&.content.presence || genre.title).strip
  end
end
