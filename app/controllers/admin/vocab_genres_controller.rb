class Admin::VocabGenresController < ApplicationController
  def index
    if current_user.comp&.channel_id.present?
      @vocab_genres = current_user.comp.channel.vocab_genres.where(vocab_genre_id: nil).order(:sort)
    else
      @vocab_genres = VocabGenre.where(vocab_genre_id: nil).order(:sort)
    end
  end

  def show
    @vocab_genre = VocabGenre.find(params[:id])
  end

  def new
    id = params[:id]
    if id.present?
      @vocab_genre = VocabGenre.new(vocab_genre_id: id)
    else
      @vocab_genre = VocabGenre.new
    end
    @vocab_genre.channel_id = current_user.comp.channel_id if current_user.comp&.channel_id.present?
  end

  def create
    @vocab_genre = VocabGenre.new(vocab_genre_params)
    @vocab_genre.channel_id = current_user.comp.channel_id if current_user.comp&.channel_id.present?
    begin
      if @vocab_genre.save
        redirect_to admin_vocab_genres_path, flash: {success: 'Created'}
      else
        render 'new'
      end
    rescue => e
      redirect_to admin_vocab_genres_path, flash: {alert: e.message}
    end
  end

  def edit
    @vocab_genre = VocabGenre.find(params[:id])
  end

  def update
    @vocab_genre = VocabGenre.find(params[:id])
    @vocab_genre.assign_attributes(vocab_genre_params)
    begin
      if @vocab_genre.save
        if @vocab_genre.vocab_genre_id.present?
          redirect_to edit_admin_vocab_genre_path, flash: {success: 'Updated'}
        else
          redirect_to admin_vocab_genres_path, flash: {success: 'Updated'}
        end
      else
        render 'edit'
      end
    rescue => e
      redirect_to admin_vocab_genres_path, flash: {alert: e.message}
    end
  end

  def destroy
    @vocab_genre = VocabGenre.find(params[:id])
    begin
      ActiveRecord::Base.transaction() do
        @vocab_genre.destroy!
        redirect_to admin_vocab_genres_path, flash: {success: 'Deleted'}
      end
    rescue => e
      logger.error(e.message)
      redirect_to admin_vocab_genres_path, flash: {alert: e.message}
    end
  end

  private

  def vocab_genre_params
    params.require(:vocab_genre).permit(
      :title,
      :sort,
      :vocab_genre_id,
      vocab_genre_contents_attributes: [
        :id,
        :sort,
        :hide_flg,
        :_destroy
      ],
      languages_attributes: [
        :id,
        :content,
        :language,
        :sort,
        :skip_flg,
        :_destroy
      ]
    )
  end
end
