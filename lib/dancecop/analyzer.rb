# frozen_string_literal: true

module DanceCop
  # Orchestrates rule execution against a practice session.
  #
  # Accepts an optional rules list for dependency injection — this makes
  # the Analyzer fully testable without relying on the global registry.
  class Analyzer
    def initialize(session, rules: Rule.registry)
      @session = session
      @rules = rules
    end

    def analyze
      offenses = @rules.flat_map { |rule_class| rule_class.new(@session).inspect }
      Report.new(session: @session, offenses: offenses)
    end
  end
end
