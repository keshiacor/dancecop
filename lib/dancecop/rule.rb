# frozen_string_literal: true

module DanceCop
  # Abstract base for all DanceCop rules.
  #
  # Subclass this and implement #inspect to create a new rule.
  # The class auto-registers itself via Ruby's `inherited` hook —
  # no manual registration required.
  #
  # Example:
  #   module DanceCop::Rules
  #     class MyCop < Rule
  #       category "MyCategory"
  #       description "Detects something interesting"
  #
  #       def inspect
  #         return [] unless notes.include?("some pattern")
  #         [offense(rule_name: "MyRule", message: "Pattern detected")]
  #       end
  #     end
  #   end
  class Rule
    @registry = []

    class << self
      # All concrete rule classes, in registration order.
      attr_reader :registry

      # Called by Ruby whenever a subclass is defined.
      def inherited(subclass)
        super
        Rule.registry << subclass
      end

      # DSL: declare the category name for this rule's offenses.
      # Defaults to class name with "Cop" stripped: TimingCop -> "Timing"
      def category(name = nil)
        if name
          @category = name
        else
          @category || self.name.split("::").last.delete_suffix("Cop")
        end
      end

      # DSL: human-readable description shown in help output.
      def description(text = nil)
        text ? @description = text : @description
      end
    end

    def initialize(session)
      @session = session
    end

    # Subclasses must implement this. Returns an Array of Offense objects.
    def inspect
      raise NotImplementedError, "#{self.class}#inspect is not implemented"
    end

    private

    attr_reader :session

    # The normalized text inspected by all rules.
    def notes = session.all_text

    def keyword_match?(keywords)
      keywords.any? { |kw| notes.include?(kw.downcase) }
    end

    def offense(rule_name:, message:, severity: :warning, drill: nil)
      Offense.new(
        rule_name: rule_name,
        category: self.class.category,
        message: message,
        severity: severity,
        drill: drill
      )
    end
  end
end
