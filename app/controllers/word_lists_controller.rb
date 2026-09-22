class WordListsController < ApplicationController
  def index
    @genres = VocabGenre.where(vocab_genre_id: nil, hide_flg: false)
                        .includes(:languages).order(:sort, :title).to_a
    @children = VocabGenre.where(vocab_genre_id: @genres.map(&:id), hide_flg: false)
                          .includes(:languages).order(:sort, :title).group_by(&:vocab_genre_id)
    @jlpt_counts = VocabTable.where(hide_flg: false, jlpt_level: 1..5).group(:jlpt_level).count
  end
end
