module VocabLinksHelper
  EXCLUDED_TEXT_ANCESTORS = %w[a button script style rt rp].freeze

  def link_vocab_text(text, channel_id: current_user&.comp&.channel_id)
    link_vocab_texts({ text: text }, channel_id: channel_id).fetch(:text)
  end

  # Plain strings are escaped. Safe HTML retains its markup and existing links.
  def link_vocab_texts(texts, channel_id: current_user&.comp&.channel_id)
    fragments = texts.transform_values do |text|
      Nokogiri::HTML5.fragment(ERB::Util.html_escape(text))
    end
    text_parts = fragments.values.flat_map do |fragment|
      fragment.xpath(".//text()").filter_map do |node|
        next unless node.content.match?(VocabTextMatcher::HAN_CHARACTER)
        next if node.ancestors.any? { |ancestor| EXCLUDED_TEXT_ANCESTORS.include?(ancestor.name) }

        [node, node.content.split(/(#{VocabTextMatcher::JAPANESE_RUN})/)]
      end
    end

    if text_parts.any?
      runs = text_parts.flat_map(&:last).grep(VocabTextMatcher::HAN_CHARACTER).uniq
      matcher = VocabTextMatcher.new(runs, channel_id: channel_id)
      segments = runs.to_h { |run| [run, matcher.segments(run)] }
      vocab_ids = segments.values.flat_map { |parts| parts.filter_map(&:last) }.uniq
      entries = VocabTable.where(id: vocab_ids).index_by(&:id)
      languages = [current_user&.lang_id, "EN"].compact.uniq
      meanings = VocabNation.where(vocab_table_id: vocab_ids, hide_flg: false, lang: languages)
        .group_by(&:vocab_table_id)
      linked_runs = segments.transform_values do |parts|
        linked_vocab_run(parts, entries, meanings, languages)
      end

      text_parts.each do |node, parts|
        node.replace(safe_join(parts.map { |part| linked_runs.fetch(part, part) }))
      end
    end

    fragments.transform_values { |fragment| fragment.to_html.html_safe }
  end

  private

  def linked_vocab_run(segments, entries, meanings, languages)
    safe_join(segments.map do |text, vocab_id|
      entry = entries[vocab_id]
      next text unless entry

      meaning = meanings.fetch(vocab_id, []).sort_by { |item| languages.index(item.lang) }
        .filter_map { |item| item.nation_code.presence }.first
      tag.button(text, type: "button", class: "vocab-popover-trigger",
        aria: { haspopup: "dialog", expanded: false },
        data: { vocab_url: jlpt_path(vocab_id), vocab_reading: entry.vocab_read,
                vocab_word: entry.vocab_code, vocab_meaning: meaning })
    end)
  end
end
