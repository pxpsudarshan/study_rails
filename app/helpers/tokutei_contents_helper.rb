module TokuteiContentsHelper
  JAPANESE_RUN = /[\p{Han}\p{Hiragana}\p{Katakana}ー]+/
  HAN_CHARACTER = /\p{Han}/
  SURU_SUFFIXES = %w[（する） (する)].freeze
  SURU_SUFFIX = /(?:#{Regexp.union(SURU_SUFFIXES)})\z/
  NEGATIVE_CONDITIONAL = "なければ".freeze
  VERB_STEM_END = /[いきぎしじちぢにひびぴみりえけげせぜてでねへべぺめれ]\z/
  KANJI_ONLY = /\A\p{Han}+\z/
  OKURIGANA = /\p{Hiragana}+\z/

  def linked_tokutei_questions(questions)
    fragments = questions.to_h do |question|
      [question.id, Nokogiri::HTML5.fragment(question.content.to_s)]
    end
    text_nodes = fragments.values.flat_map do |fragment|
      fragment.xpath(".//text()").reject do |node|
        node.ancestors.any? { |ancestor| %w[a script style rt rp].include?(ancestor.name) }
      end
    end
    runs = text_nodes.flat_map { |node| node.content.scan(JAPANESE_RUN) }.uniq
    candidates = runs.flat_map do |run|
      (0...run.length).flat_map do |start|
        (1..(run.length - start)).filter_map do |length|
          word = run[start, length]
          word if word.match?(HAN_CHARACTER)
        end
      end
    end.uniq

    channel_id = current_user.comp&.channel_id
    vocab_codes = candidates.flat_map do |word|
      [word, *SURU_SUFFIXES.map { |suffix| word + suffix }]
    end
    visible_vocab = VocabTable.comp_vocab_tables(channel_id).where(hide_flg: false)
    exact_codes = visible_vocab.where(vocab_code: vocab_codes)
      .order(:sort, :id)
      .pluck(:vocab_code, :id)
      .each_with_object({}) { |(word, id), ids| ids[word] ||= id }

    vocab_ids = exact_codes.each_with_object({}) do |(code, id), ids|
      word = code.sub(SURU_SUFFIX, "")
      ids[word] ||= exact_codes.fetch(word, id)
    end
    okurigana_matches = unique_okurigana_matches(visible_vocab, candidates.grep(KANJI_ONLY))

    text_nodes.each do |node|
      next unless node.content.match?(HAN_CHARACTER)

      html = node.content.split(/(#{JAPANESE_RUN})/).flat_map do |part|
        part.match?(HAN_CHARACTER) ? link_tokutei_vocab_run(part, vocab_ids, okurigana_matches) : [part]
      end
      node.replace(safe_join(html))
    end

    fragments.transform_values { |fragment| fragment.to_html.html_safe }
  end

  private

  def unique_okurigana_matches(visible_vocab, kanji_words)
    return {} if kanji_words.empty?

    pattern = "^(#{kanji_words.join('|')})[ぁ-ゖ]+$"
    visible_vocab.where("vocab_code ~ ?", pattern)
      .order(:sort, :id)
      .pluck(:vocab_code, :id)
      .uniq(&:first)
      .group_by { |code, _id| code.sub(OKURIGANA, "") }
      .each_with_object({}) do |(kanji, entries), matches|
        matches[kanji] = entries.first if entries.one?
      end
  end

  def link_tokutei_vocab_run(run, vocab_ids, okurigana_matches)
    parts = []
    offset = 0
    while offset < run.length
      vocab_id = nil
      length = (run.length - offset).downto(1).find do |size|
        word = run[offset, size]
        vocab_id = vocab_ids[word] || okurigana_matches[word]&.last
        if !vocab_id && word.match?(VERB_STEM_END) &&
            run[offset + size, NEGATIVE_CONDITIONAL.length] == NEGATIVE_CONDITIONAL
          code, id = okurigana_matches[word.sub(OKURIGANA, "")]
          vocab_id = id if code == word + "る"
        end
        vocab_id
      end
      word = run[offset, length || 1]
      parts << if length
        link_to word, jlpt_path(vocab_id), target: "_blank", rel: "noopener"
      else
        word
      end
      offset += word.length
    end
    parts
  end
end
