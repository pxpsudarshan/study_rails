require 'set'

# Match every visible subgenre of recent words; completion includes descendants,
# just like the vocabulary list opened by the continue link.
class RecentStudyGenres
  def initialize(user, recent_cards)
    @user = user
    @recent_cards = recent_cards
  end

  def call
    recent_ids = @recent_cards.map(&:vocab_table_id)
    return [] if recent_ids.empty?

    genres = VocabGenre.where(hide_flg: false).includes(:languages).to_a
    by_id = genres.index_by(&:id)
    children = genres.group_by(&:vocab_genre_id)
    memberships = VocabGenreContent.where(hide_flg: false, vocab_table_id: recent_ids)
    candidate_ids = memberships.distinct.pluck(:vocab_genre_id)
    candidates = genres.select do |genre|
      candidate_ids.include?(genre.id) && genre.vocab_genre_id.present? && visible_tree?(genre, by_id)
    end
    trees = candidates.to_h { |genre| [genre.id, descendant_ids(genre.id, children)] }
    contents = VocabGenreContent.joins(:vocab_table)
                               .where(hide_flg: false, vocab_genre_id: trees.values.flatten.uniq,
                                      vocab_tables: { hide_flg: false })
                               .pluck(:vocab_genre_id, :vocab_table_id).group_by(&:first)
    learned_ids = @user.vocab_mycards.where(mycard_level: 1).pluck(:vocab_table_id).to_set

    candidates.filter_map do |genre|
      word_ids = trees.fetch(genre.id).flat_map { |id| (contents[id] || []).map(&:last) }.to_set
      next if word_ids.empty?

      learned = (word_ids & learned_ids).size
      root = genre
      root = by_id.fetch(root.vocab_genre_id) while root.vocab_genre_id.present?
      { genre: genre, root: root, learned: learned, total: word_ids.size,
        percent: learned * 100.0 / word_ids.size }
    end.sort_by do |entry|
      [entry[:learned] == entry[:total] ? 1 : 0, -entry[:percent], -entry[:learned], entry[:genre].title.to_s]
    end
  end

  private

  def visible_tree?(genre, by_id)
    seen = Set.new
    while genre
      return false unless seen.add?(genre.id)
      return true if genre.vocab_genre_id.blank?
      genre = by_id[genre.vocab_genre_id]
    end
    false
  end

  def descendant_ids(id, children, seen = Set.new)
    return [] unless seen.add?(id)
    [id] + (children[id] || []).flat_map { |child| descendant_ids(child.id, children, seen) }
  end
end
