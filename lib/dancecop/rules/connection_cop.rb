# frozen_string_literal: true

module DanceCop
  module Rules
    class ConnectionCop < Rule
      category "Connection"
      description "Detects lead/follow connection and partnership quality issues"

      PATTERNS = {
        Lead: {
          keywords: ["too much force", "forcing", "pulling too hard", "yanking", "excessive force", "pushing"],
          message: "Excessive force in lead — connection should be invitation, not instruction",
          drill: "Feather touch drill: lead with fingertip pressure only, no gripping"
        },
        Follow: {
          keywords: ["anticipating", "back-leading", "not following", "guessing the move"],
          message: "Follow anticipating signals — wait for the lead to complete",
          drill: "Blindfolded follow exercise: close eyes, respond only to physical cues"
        },
        Tension: {
          keywords: ["arm tension", "too stiff", "rigid", "too tense", "stiff arms"],
          message: "Arm tension disrupting connection elasticity",
          drill: "Resistance band warm-up: gentle dynamic stretching before partnering"
        },
        CrossBodyLead: {
          keywords: ["cross body", "cbl", "cross-body", "lost connection on cross"],
          message: "Connection breakdown during cross body lead",
          drill: "Slow-motion CBL: walk through at 30% tempo, feel each weight transfer"
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
