# frozen_string_literal: true

module DanceCop
  module Rules
    class TimingCop < Rule
      category "Timing"
      description "Detects timing and rhythm issues in practice notes"

      PATTERNS = {
        BasicStep: {
          keywords: ["rushed", "rushing", "behind the beat", "off beat", "lost the beat", "early"],
          message: "Off beat tendency detected",
          drill: "Basic step with metronome — start at 60 BPM, increase by 5"
        },
        RhythmConsistency: {
          keywords: ["lost timing", "off time", "out of time", "tempo", "lost the rhythm"],
          message: "Rhythm consistency issues detected",
          drill: "Clave pattern isolation: clap the clave, then add footwork"
        },
        Musicality: {
          keywords: ["musicality", "not hearing the music", "counting", "missed the break"],
          message: "Musicality and musical phrasing needs development",
          drill: "Listen-and-freeze: pause movement on every 8-count phrase end"
        }
      }.freeze

      def inspect
        PATTERNS.filter_map do |rule_name, pattern|
          next unless keyword_match?(pattern[:keywords])

          offense(
            rule_name: rule_name.to_s,
            message: pattern[:message],
            drill: pattern[:drill]
          )
        end
      end
    end
  end
end
