module MenusHelper
  def study_genre_title(genre)
    return genre.title if current_user.lang_id == 'JP'

    get_content(genre, current_user.lang_id).presence || genre.title
  end
end
