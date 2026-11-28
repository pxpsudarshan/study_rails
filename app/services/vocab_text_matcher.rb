class VocabTextMatcher
  JAPANESE_RUN = /[\p{Han}\p{Hiragana}\p{Katakana}ー]+/
  HAN_CHARACTER = /\p{Han}/
  KANJI_ONLY = /\A\p{Han}+\z/
  OKURIGANA = /\p{Hiragana}+\z/
  SURU_SUFFIXES = %w[（する） (する)].freeze
  SURU_SUFFIX = /(?:#{Regexp.union(SURU_SUFFIXES)})\z/
  TILDE_PREFIXES = %w[～ 〜].freeze
  TILDE_PREFIX = /\A#{Regexp.union(TILDE_PREFIXES)}/

  def initialize(runs, channel_id:)
    candidates = candidate_words(runs)
    scope = VocabTable.comp_vocab_tables(channel_id).where(hide_flg: false)
    exact = exact_matches(scope, candidates)
    prefixes = unique_okurigana_prefixes(scope, candidates.grep(KANJI_ONLY))
    @matches = prefixes.merge(exact)
    @max_match_length = @matches.keys.map(&:length).max.to_i
  end

  def segments(run)
    parts = []
    offset = 0

    while offset < run.length
      match = longest_match(run, offset)
      if match
        parts << match
        offset += match.first.length
      else
        parts << [run[offset], nil]
        offset += 1
      end
    end

    parts
  end

  private

  def candidate_words(runs)
    words = Set.new
    runs.each do |run|
      last_index = run.length - 1
      (0..last_index).each do |start|
        first_kanji = run.index(HAN_CHARACTER, start)
        break unless first_kanji

        (first_kanji..last_index).each do |finish|
          words.add(run[start..finish])
        end
      end
    end
    words
  end

  def exact_matches(scope, candidates)
    codes = candidates.flat_map do |word|
      forms = [word, *SURU_SUFFIXES.map { |suffix| word + suffix }]
      forms + TILDE_PREFIXES.flat_map { |prefix| forms.map { |form| prefix + form } }
    end
    ids = scope.where(vocab_code: codes).order(:sort, :id).pluck(:vocab_code, :id)
      .each_with_object({}) { |(code, id), result| result[code] ||= id }

    plain, marked = ids.keys.partition { |code| !code.match?(TILDE_PREFIX) }
    (plain + marked).each_with_object({}) do |code, matches|
      base = code.sub(SURU_SUFFIX, "")
      word = base.sub(TILDE_PREFIX, "")
      matches[word] ||= ids.fetch(base, ids.fetch(code))
    end
  end

  def unique_okurigana_prefixes(scope, kanji_words)
    return {} if kanji_words.empty?

    pattern = "^(#{kanji_words.join('|')})[ぁ-ゖ]+$"
    groups = scope.where("vocab_code ~ ?", pattern).order(:sort, :id).pluck(:vocab_code, :id)
      .uniq(&:first)
      .group_by { |code, _id| code.sub(OKURIGANA, "") }

    groups.each_with_object({}) do |(kanji, entries), matches|
      next unless entries.one?

      code, id = entries.first
      (kanji.length...code.length).each do |length|
        matches[code[0, length]] = id
      end
    end
  end

  def longest_match(run, offset)
    max_length = [run.length - offset, @max_match_length].min
    max_length.downto(1) do |length|
      word = run[offset, length]
      id = @matches[word]
      return [word, id] if id
    end

    nil
  end
end
