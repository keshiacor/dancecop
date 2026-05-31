# frozen_string_literal: true

require_relative "dancecop/version"
require_relative "dancecop/offense"
require_relative "dancecop/practice_session"
require_relative "dancecop/rule"
require_relative "dancecop/analyzer"
require_relative "dancecop/coach"
require_relative "dancecop/report"
require_relative "dancecop/session_builder"

# Rules auto-register themselves when required — order matters only for
# display, not correctness.
require_relative "dancecop/rules/timing_cop"
require_relative "dancecop/rules/frame_cop"
require_relative "dancecop/rules/connection_cop"
require_relative "dancecop/rules/balance_cop"

module DanceCop
  # The practice DSL entry point.
  #
  #   report = DanceCop.practice do
  #     style :salsa
  #     issue "Rushed the basic step"
  #     instructor_feedback "Keep elbows up"
  #   end
  #
  #   puts report
  def self.practice(&block)
    builder = SessionBuilder.new
    builder.instance_eval(&block)
    Analyzer.new(builder.build).analyze
  end
end
