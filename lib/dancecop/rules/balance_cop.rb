# frozen_string_literal: true

module DanceCop
  module Rules
    class BalanceCop < Rule
      category "Balance"
      description "Detects balance, weight transfer, and footwork issues"

      PATTERNS = {
        WeightTransfer: {
          keywords: ["weight transfer", "flat-footed", "flat footed", "heavy feet", "stomping"],
          message: "Incomplete weight transfer — steps should be decisive and grounded",
          drill: "Single-leg balance hold: 30 seconds each side, eyes open then closed"
        },
        Turns: {
          keywords: ["falling out of turns", "off-balance in turns", "wobbling", "stumbling on turns", "unstable turns"],
          message: "Balance instability during turns detected",
          drill: "Spot-turn drill: slow pirouette with fixed gaze point, 10 reps each direction"
        },
        Core: {
          keywords: ["core", "abs", "center", "stabilize", "unstable", "shaky"],
          message: "Core engagement insufficient for stable movement",
          drill: "Plank hold with salsa timing: engage core for 4-counts, release for 4-counts"
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
