# Parses plain-text SRT and WebVTT cues; markup is removed before display.
class SubtitleParser
  class Invalid < StandardError; end
  MAX_BYTES = 2.megabytes
  TIMESTAMP = /\A(?:(\d{2,}):)?([0-5]\d):([0-5]\d)[.,](\d{3})\z/

  def self.parse(source, skip_non_displayable: false)
    raise Invalid, 'Subtitle file must be smaller than 2 MB.' if source.bytesize > MAX_BYTES
    text = source.dup.force_encoding(Encoding::UTF_8)
    raise Invalid, 'Use a UTF-8 encoded subtitle file.' unless text.valid_encoding?
    text = text.delete_prefix("\uFEFF").gsub(/\r\n?/, "\n").strip
    cues = []
    text.split(/\n[ \t]*\n/).each do |block|
      lines = block.lines.map(&:strip)
      next if lines.first.match?(/\A(?:WEBVTT|NOTE|STYLE|REGION)(?:\s|\z)/)
      lines.shift unless lines.first.include?('-->')
      timing = lines.shift.to_s.match(/\A(\S+)\s+-->\s+(\S+)(?:\s+.*)?\z/)
      raise Invalid, 'Invalid subtitle timing. Upload an SRT or WebVTT file.' unless timing
      start_time, end_time = timing.captures.map { |value| timestamp(value) }
      content = ActionController::Base.helpers.strip_tags(lines.join("\n")).strip
      # Imported tracks can contain blank clearing cues or instantaneous cues.
      # They cannot become clickable sentences; preserve gaps by omitting them.
      # Reversed timing is still an error, even for imported captions.
      if skip_non_displayable && end_time >= start_time && (content.empty? || end_time == start_time)
        next
      end
      raise Invalid, 'Each subtitle must have text and an end time after its start.' if content.empty? || end_time <= start_time
      cues << { 'start' => start_time, 'end' => end_time, 'text' => content }
      raise Invalid, 'Use a file with at most 10,000 subtitle lines.' if cues.size > 10_000
    end
    raise Invalid, 'No subtitles found in this file.' if cues.empty?
    cues.sort_by { |cue| cue['start'] }
  end

  def self.timestamp(value)
    match = TIMESTAMP.match(value)
    raise Invalid, "Invalid subtitle timestamp: #{value}" unless match
    match[1].to_i * 3600 + match[2].to_i * 60 + match[3].to_i + match[4].to_i / 1000.0
  end
  private_class_method :timestamp
end
