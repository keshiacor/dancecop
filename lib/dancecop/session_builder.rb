# frozen_string_literal: true

module DanceCop
  # Accumulates practice session data via the DanceCop.practice DSL.
  #
  # Uses instance_eval so the block's method calls resolve against this
  # builder, giving callers a clean vocabulary without explicit receivers:
  #
  #   DanceCop.practice do
  #     style :salsa
  #     issue "Rushed the basic step"
  #     instructor_feedback "Keep elbows up"
  #   end
  class SessionBuilder
    def initialize
      @issues = []
      @instructor_feedback = []
      @style = nil
      @metadata = {}
    end

    def style(name)
      @style = name
      self
    end

    def issue(text)
      @issues << text.to_s
      self
    end

    def instructor_feedback(text)
      @instructor_feedback << text.to_s
      self
    end

    def metadata(**kwargs)
      @metadata.merge!(kwargs)
      self
    end

    def build
      PracticeSession.new(
        notes: @issues.join("\n"),
        style: @style,
        instructor_feedback: @instructor_feedback,
        metadata: @metadata
      )
    end
  end
end
