# frozen_string_literal: true

module DanceCop
  module Rules
    class FrameCop < Rule
      category "Frame"
      description "Detects posture, frame, and body mechanics issues"

      PATTERNS = {
        Posture: {
          keywords: ["frame collapsed", "hunching", "slouching", "shoulders dropped", "posture"],
          message: "Frame instability detected — upper body structure needs attention",
          drill: "Wall frame drill: maintain contact with wall while stepping side-to-side"
        },
        Elbows: {
          keywords: ["elbows down", "elbows dropping", "arms too low", "keep elbows up"],
          message: "Elbow position falling — affects connection and lead clarity",
          drill: "Book-on-forearm drill: balance object on forearm to reinforce elbow height"
        },
        HeadPosition: {
          keywords: ["looking down", "head down", "eyes on feet", "neck"],
          message: "Head position breaking frame alignment",
          drill: "Eyes-up basic: practice basics with gaze fixed at partner eye level"
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
