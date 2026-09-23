require 'minitest/autorun'
require 'active_support/core_ext/numeric/bytes'
require 'action_controller'
require_relative '../../app/services/subtitle_parser'

class SubtitleParserTest < Minitest::Test
  def test_srt_with_bom_crlf_multiline_and_markup
    cues = SubtitleParser.parse("\uFEFF1\r\n00:00:01,250 --> 00:00:03,000\r\n<b>Hello</b>\r\n世界\r\n")
    assert_equal [{ 'start' => 1.25, 'end' => 3.0, 'text' => "Hello\n世界" }], cues
  end

  def test_webvtt_headers_notes_identifiers_and_settings
    cues = SubtitleParser.parse("WEBVTT\nKind: captions\n\nNOTE ignore this\n\nfirst\n00:02.000 --> 00:04.500 align:start\n<v Speaker>Hello</v>\n")
    assert_equal 2.0, cues.first['start']
    assert_equal 'Hello', cues.first['text']
  end

  def test_rejects_empty_invalid_and_reversed_cues
    ['', 'WEBVTT', "00:61.000 --> 00:62.000\nBad", "00:02.000 --> 00:01.000\nBad", "00:01.000 --> 00:02.000\n", "\xFF".b].each do |input|
      assert_raises(SubtitleParser::Invalid) { SubtitleParser.parse(input) }
    end
  end

  def test_import_omits_blank_and_zero_duration_cues_without_changing_valid_timings
    source = "WEBVTT\n\n00:00.000 --> 00:01.000\n\n00:01.000 --> 00:03.000\nこんにちは\n\n00:03.000 --> 00:03.000\nInstantaneous\n\n00:03.000 --> 00:04.000\n<b></b>\n\n00:04.000 --> 00:05.000\n世界\n"
    cues = SubtitleParser.parse(source, skip_non_displayable: true)
    assert_equal [
      { 'start' => 1.0, 'end' => 3.0, 'text' => 'こんにちは' },
      { 'start' => 4.0, 'end' => 5.0, 'text' => '世界' }
    ], cues
  end

  def test_import_still_rejects_reversed_timing_and_tracks_without_usable_text
    ["00:02.000 --> 00:01.000\nBad", "00:01.000 --> 00:02.000\n", "00:01.000 --> 00:01.000\nInstant"].each do |source|
      assert_raises(SubtitleParser::Invalid) { SubtitleParser.parse(source, skip_non_displayable: true) }
    end
  end

  def test_upload_still_rejects_zero_duration_cues
    assert_raises(SubtitleParser::Invalid) { SubtitleParser.parse("00:01.000 --> 00:01.000\nInstant") }
  end

  def test_size_limit
    assert_raises(SubtitleParser::Invalid) { SubtitleParser.parse('a' * (SubtitleParser::MAX_BYTES + 1)) }
  end
end
