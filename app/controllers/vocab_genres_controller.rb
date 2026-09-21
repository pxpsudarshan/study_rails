class VocabGenresController < ApplicationController
  after_action :set_breadcrumb_label, only: :index

  def index
    @id       = params[:id]
    child_id  = params[:child_id]
    redirect_to menus_path and return unless @id.present?

    # Parents (root genres) for the given title
    @root_genre = VocabGenre.find(@id)
    @selected_genre = child_id.present? ? VocabGenre.find(child_id) : @root_genre
    parent = @selected_genre

    ids = []
    sub_ids = []

    table_ids = []
    table_ids << parent.id
    while id = table_ids.shift
      vg = VocabGenre.find(id)
      ids += vg.vocab_genre_contents.where(hide_flg: false).pluck(:vocab_table_id)
      table_ids += vg.sub_genres.where(hide_flg: false).pluck(:id)
    end

    table_ids = []
    table_ids << @id
    while id = table_ids.shift
      vg = VocabGenre.find(id)
      sub_maps = vg.sub_genres.where(hide_flg: false).pluck(:id)
      table_ids += sub_maps
      sub_ids += sub_maps
    end

    # A selected child must belong to the requested genre tree.
    raise ActiveRecord::RecordNotFound unless @selected_genre.id == @root_genre.id || sub_ids.include?(@selected_genre.id)

    # Children for the select (unique rows, stable order)
    @children = VocabGenre.where(id: sub_ids).select(:title, :sort, :id).order(:sort, :title)

    # Cards: filter by selected child (by title) or use parent tables
    @cards = VocabTable.where(id: ids, hide_flg: false).order(:created_at)
                       .page(params[:page])
                       .per(params[:per].present? ? params[:per].to_i.clamp(1, 100) : 20)
  end

  def show
    vocab = VocabTable.find(params[:id])
    vocab_code = vocab.vocab_code
    jlpt_level = vocab.jlpt_level
    @gois = {
      vocab_read: vocab.vocab_read,
      vocab_code: vocab_code,
      jlpt_level: 'N'+jlpt_level.to_s,
      vocab_kanji: vocab.kanji_tables,
      eng_mean: vocab.vocab_nations.where(hide_flg: false, lang: 'EN').first,
      nation_mean: vocab,
    }
    @cards = vocab_cards(vocab_code)
    @count = 1
    @mycard = current_user.vocab_mycards.where(vocab_table_id: vocab.id).first
    @vocab_mycard = @mycard.present? ? '⭐️' : '☆'
    current_user.vocab_mycards.create!(vocab_table_id: vocab.id) if @mycard.blank?
  end

  private

  def set_breadcrumb_label
    return unless request.get? && response.successful? && @cards

    # AJAX pagination needs the same readable title as a full page load.
    response.set_header('X-Breadcrumb-Label', ERB::Util.url_encode(view_context.breadcrumb_genre_label(@root_genre, @selected_genre)))
  end
end
