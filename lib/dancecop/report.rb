# frozen_string_literal: true

module DanceCop
  # The result of an analysis run: an enumerable collection of offenses
  # with a human-readable string representation.
  #
  # Including Enumerable over the offenses means callers get .count,
  # .any?, .select, .group_by, etc. for free — a key Ruby idiom.
  class Report
    include Enumerable
    include Comparable

    attr_reader :session

    def initialize(session:, offenses:)
      @session = session
      @offenses = offenses.freeze
      @coach = Coach.new(offenses)
    end

    # Enumerable interface — yields each offense.
    def each(&block)
      @offenses.each(&block)
    end

    # Comparable — compare reports by offense count (useful in testing suites).
    def <=>(other)
      count <=> other.count
    end

    def clean? = none?

    def to_s
      clean? ? clean_report : offense_report
    end

    private

    def clean_report
      [header, "", "  No offenses detected. Keep dancing!", ""].join("\n")
    end

    def offense_report
      lines = [header, ""]

      @offenses.each do |offense|
        lines << offense.to_s
        lines << ""
      end

      lines << offense_summary
      lines << ""

      if @coach.any_recommendations?
        lines << "Recommended Focus:"
        @coach.focus_areas.each { |area| lines << "  #{area}" }
        lines << ""
        lines << "Suggested Drills:"
        @coach.suggested_drills.each { |drill| lines << "  - #{drill}" }
      end

      lines.join("\n")
    end

    def header
      title = "DanceCop Report"
      [title, "=" * title.length].join("\n")
    end

    def offense_summary
      n = count
      suffix = (n == 1) ? "" : "s"
      "#{n} offense#{suffix} detected"
    end
  end
end
