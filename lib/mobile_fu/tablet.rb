# frozen_string_literal: true

module MobileFu
  module Tablet
    QUICK_TABLET_HINTS = /ipad|tablet|android|kindle|silk|playbook|touch|pad|tab|slate|nexus|xoom|transformer|mediapad|ideapad|thinkpad|surface|jolla/i

    # Базовые признаки современных и распространенных планшетов
    TABLET_PATTERNS = [
      /ipad/i,
      /tablet/i,
      /kindle|silk/i,
      /playbook|rim tablet/i,
      /galaxy.*tab|sm-t\d+|sm-p\d+|gt-p\d+|gt-n\d+/i,
      /nexus[\s]+(7|9|10)/i,
      /xoom|transformer|mediapad|ideapad|thinkpad.*tablet|surface|jolla/i,
      /windows nt [0-9.]+; arm;/i
    ].freeze

    TABLET_REGEX = Regexp.union(TABLET_PATTERNS).freeze

    def self.is_a_tablet_device?(user_agent)
      return false if user_agent.blank?

      safe_ua = user_agent.to_s.byteslice(0, 300)
      return false unless QUICK_TABLET_HINTS.match?(safe_ua)

      # В Android планшеты (в отличие от телефонов) не содержат слово "Mobile" в User-Agent
      return true if safe_ua.match?(/android/i) && !safe_ua.match?(/mobile/i)

      TABLET_REGEX.match?(safe_ua)
    rescue Regexp::TimeoutError
      false
    end
  end
end
