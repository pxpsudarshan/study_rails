class Admin::VideoGenresController < Admin::VideoBaseController
  before_action :set_genre, only: %i[show edit update destroy]
  before_action :set_parents, only: %i[new create edit update]

  def index
    @video_genres = managed(VideoGenre).where(video_genre_id: nil).ordered.includes(:channel, :sub_genres)
  end

  def show
    @sub_genres = @video_genre.sub_genres.ordered
    @video_lessons = @video_genre.video_lessons.order(:sort, :title)
  end

  def new
    @video_genre = VideoGenre.new(channel_id: current_user.comp&.channel_id)
    if params[:parent_id].present?
      parent = managed(VideoGenre).where(video_genre_id: nil).find(params[:parent_id])
      @video_genre.assign_attributes(video_genre: parent, channel_id: parent.channel_id)
    end
  end

  def create
    @video_genre = VideoGenre.new(channel_id: current_user.comp&.channel_id)
    assign_genre
    if @video_genre.save
      redirect_to [:admin, @video_genre]
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    assign_genre
    if @video_genre.save
      redirect_to [:admin, @video_genre]
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @video_genre.destroy!
    redirect_to admin_video_genres_path, status: :see_other
  end

  private

  def set_genre
    @video_genre = managed(VideoGenre).find(params[:id])
  end

  def set_parents
    @parents = managed(VideoGenre).where(video_genre_id: nil).ordered
  end

  def assign_genre
    attributes = params.require(:video_genre).permit(:title, :content, :sort, :hide_flg, :video_genre_id)
    parent_id = attributes.delete(:video_genre_id)
    parent = managed(VideoGenre).where(video_genre_id: nil).find(parent_id) if parent_id.present?
    @video_genre.assign_attributes(attributes)
    @video_genre.video_genre = parent
    @video_genre.channel_id = parent.channel_id if parent && @video_genre.new_record?
  end
end
