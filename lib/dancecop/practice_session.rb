# frozen_string_literal: true

module DanceCop
  class PracticeSession
    attr_reader :notes, :style, :instructor_feedback, :metadata

    def initialize(notes:, style: nil, instructor_feedback: [], metadata: {})
      @notes = notes.to_s.strip
      @style = style
      @instructor_feedback = Array(instructor_feedback).map(&:to_s).freeze
      @metadata = metadata.freeze
      freeze
    end

    # Rules inspect this unified text — both notes and instructor feedback
    # are fair game for pattern detection.
    def all_text
      [@notes, *@instructor_feedback].join("\n").downcase
    end

    def empty?
      @notes.empty? && @instructor_feedback.empty?
    end
  end
end
