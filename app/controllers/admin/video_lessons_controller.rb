class Admin::VideoLessonsController < Admin::VideoBaseController
  before_action :set_categories
  before_action :set_lesson, only: %i[show edit update destroy refresh_youtube]

  def index
    @video_lessons = lessons.includes(video_genre: :video_genre).order(created_at: :desc).page(params[:page]).per(12)
  end

  def new
    @video_lesson = VideoLesson.new(user: current_user, channel_id: current_user.comp&.channel_id)
    preselect_category
  end

  def create
    @video_lesson = VideoLesson.new(lesson_params.merge(user: current_user, channel_id: current_user.comp&.channel_id))
    assign_category
    if @video_lesson.save
      redirect_to [:admin, @video_lesson]
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show; end
  def edit; end

  def update
    @video_lesson.assign_attributes(lesson_params)
    assign_category
    if @video_lesson.save
      redirect_to [:admin, @video_lesson]
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @video_lesson.destroy!
    redirect_to admin_video_lessons_path, status: :see_other
  end

  def youtube_import
    @video_lesson = VideoLesson.new(user: current_user, channel_id: current_user.comp&.channel_id)
    preselect_category
  end

  def youtube_tracks
    @video_lesson = VideoLesson.new(import_params.merge(user: current_user, channel_id: current_user.comp&.channel_id))
    @video_lesson.valid?
    if @video_lesson.errors[:youtube_video_id].any? || @video_lesson.errors[:title].any?
      flash.now[:alert] = t('video_learning.youtube.invalid_video')
    else
      @tracks = youtube_api.tracks(@video_lesson.youtube_video_id)
      flash.now[:alert] = t('video_learning.youtube.no_tracks') if @tracks.empty?
    end
    render :youtube_import
  rescue YoutubeApi::Error => e
    flash.now[:alert] = e.message
    render :youtube_import, status: :unprocessable_entity
  end

  def import_youtube
    @video_lesson = VideoLesson.new(import_params.merge(user: current_user, channel_id: current_user.comp&.channel_id))
    @video_lesson.valid?
    if @video_lesson.errors[:youtube_video_id].any? || @video_lesson.errors[:title].any?
      flash.now[:alert] = t('video_learning.youtube.invalid_video')
      return render :youtube_import, status: :unprocessable_entity
    end
    @video_lesson.subtitle_cues = youtube_api.download(@video_lesson.youtube_video_id, params[:caption_id].to_s)
    @video_lesson.youtube_caption_id = params[:caption_id]
    assign_category
    @video_lesson.save!
    redirect_to [:admin, @video_lesson]
  rescue YoutubeApi::Error, SubtitleParser::Invalid => e
    flash.now[:alert] = e.message
    render :youtube_import, status: :unprocessable_entity
  end

  def refresh_youtube
    cues = youtube_api.download(@video_lesson.youtube_video_id, @video_lesson.youtube_caption_id)
    @video_lesson.update!(subtitle_cues: cues)
    redirect_to [:admin, @video_lesson], notice: t('video_learning.youtube.refreshed')
  rescue YoutubeApi::Error, SubtitleParser::Invalid => e
    redirect_to [:admin, @video_lesson], alert: e.message
  end

  private

  def preselect_category
    return if params[:video_genre_id].blank?
    category = managed(VideoGenre).find(params[:video_genre_id])
    @video_lesson.assign_attributes(video_genre: category, channel_id: category.channel_id)
  end

  def set_categories
    @categories = managed(VideoGenre).includes(:video_genre).ordered
  end

  def assign_category
    id = params.dig(:video_lesson, :video_genre_id)
    @video_lesson.video_genre = id.present? ? managed(VideoGenre).find(id) : nil
    @video_lesson.channel_id = @video_lesson.video_genre.channel_id if @video_lesson.video_genre
  end

  def youtube_api
    YoutubeApi.new(YoutubeConnection.find_by(user: current_user))
  end

  def import_params
    params.require(:video_lesson).permit(:title, :youtube_url)
  end


  def lessons
    managed(VideoLesson)
  end

  def set_lesson
    @video_lesson = lessons.find(params[:id])
  end

  def lesson_params
    params.require(:video_lesson).permit(:title, :youtube_url, :subtitle_file, :content, :sort, :hide_flg)
  end
end
