# frozen_string_literal: true

module DanceCop
  # Converts detected offenses into prioritized coaching recommendations.
  #
  # The Coach is intentionally separate from the rules — rules detect,
  # the coach advises. This separation makes it straightforward to swap
  # in an AI coach (DanceCop::LLMCoach) in a future version.
  class Coach
    CATEGORY_PRIORITY = {
      "Timing" => 1,
      "Balance" => 2,
      "Frame" => 3,
      "Connection" => 4
    }.freeze

    def initialize(offenses)
      @offenses = offenses
    end

    # Returns unique focus area categories, sorted by coaching priority.
    # Timing fundamentals come before stylistic concerns.
    def focus_areas
      @offenses
        .map(&:category)
        .uniq
        .sort_by { |cat| CATEGORY_PRIORITY.fetch(cat, 99) }
    end

    # Returns unique drills sourced directly from the triggered offenses.
    def suggested_drills
      @offenses.filter_map(&:drill).uniq
    end

    def any_recommendations? = focus_areas.any?
  end
end
