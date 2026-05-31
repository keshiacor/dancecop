# frozen_string_literal: true

RSpec.describe DanceCop::Coach do
  def offense(category:, drill: nil)
    DanceCop::Offense.new(rule_name: "X", category: category, message: "msg", drill: drill)
  end

  describe "#focus_areas" do
    it "returns unique categories from offenses" do
      coach = described_class.new([
        offense(category: "Timing"),
        offense(category: "Timing"),
        offense(category: "Frame")
      ])
      expect(coach.focus_areas).to eq(["Timing", "Frame"])
    end

    it "orders by coaching priority (Timing before Balance before Frame before Connection)" do
      coach = described_class.new([
        offense(category: "Connection"),
        offense(category: "Timing"),
        offense(category: "Balance"),
        offense(category: "Frame")
      ])
      expect(coach.focus_areas).to eq(["Timing", "Balance", "Frame", "Connection"])
    end

    it "puts unknown categories last" do
      coach = described_class.new([
        offense(category: "Experimental"),
        offense(category: "Timing")
      ])
      expect(coach.focus_areas.first).to eq("Timing")
      expect(coach.focus_areas.last).to eq("Experimental")
    end
  end

  describe "#suggested_drills" do
    it "returns unique drills from offenses" do
      coach = described_class.new([
        offense(category: "Timing", drill: "Metronome drill"),
        offense(category: "Timing", drill: "Metronome drill"),
        offense(category: "Frame", drill: "Wall frame drill")
      ])
      expect(coach.suggested_drills).to eq(["Metronome drill", "Wall frame drill"])
    end

    it "excludes nil drills" do
      coach = described_class.new([offense(category: "Timing", drill: nil)])
      expect(coach.suggested_drills).to be_empty
    end
  end

  describe "#any_recommendations?" do
    it "returns false when there are no offenses" do
      expect(described_class.new([])).not_to be_any_recommendations
    end

    it "returns true when offenses are present" do
      expect(described_class.new([offense(category: "Timing")])).to be_any_recommendations
    end
  end
end
