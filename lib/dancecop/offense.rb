# frozen_string_literal: true

module DanceCop
  # An immutable record of a detected issue in a practice session.
  #
  # Uses Data.define (Ruby 3.2+) for value semantics: two Offense objects
  # with identical fields are equal, and every instance is frozen at creation.
  # This mirrors how RuboCop treats offenses as facts, not mutable state.
  Offense = Data.define(:rule_name, :category, :message, :severity, :drill) do
    def initialize(rule_name:, category:, message:, severity: :warning, drill: nil)
      super
    end

    def to_s
      "#{category}/#{rule_name}\n  #{message}"
    end

    def error? = severity == :error
    def warning? = severity == :warning
  end
end
