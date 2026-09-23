class VideoLessonsController < ApplicationController
  def index
    @genres = VideoGenre.visible_to(current_user).includes(:video_genre).ordered
    @selected_genre = @genres.find(params[:genre_id]) if params[:genre_id].present?
    lessons = VideoLesson.visible_to(current_user).includes(:video_genre)
    if @selected_genre
      ids = [@selected_genre.id] + @genres.where(video_genre_id: @selected_genre.id).pluck(:id)
      lessons = lessons.where(video_genre_id: ids)
    end
    @query = params[:q].to_s.strip.first(200)
    lessons = lessons.where('video_lessons.title ILIKE ?', "%#{VideoLesson.sanitize_sql_like(@query)}%") if @query.present?
    @video_lessons = lessons.select(:id, :title, :content, :video_genre_id, :youtube_video_id, :sort, 'jsonb_array_length(subtitle_cues) AS subtitle_count').order(:sort, :title, :id).page(params[:page]).per(12)
  end

  def show
    @video_lesson = VideoLesson.visible_to(current_user).find(params[:id])
    ordered = VideoLesson.visible_to(current_user).where(video_genre_id: @video_lesson.video_genre_id).select(:id, :title).order(:sort, :title, :id).to_a
    index = ordered.index { |lesson| lesson.id == @video_lesson.id }
    @previous_lesson = ordered[index - 1] if index.positive?
    @next_lesson = ordered[index + 1]
  end
end
