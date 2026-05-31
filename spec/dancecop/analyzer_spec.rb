# frozen_string_literal: true

RSpec.describe DanceCop::Analyzer do
  def session_with(notes)
    DanceCop::PracticeSession.new(notes: notes)
  end

  describe "#analyze" do
    it "returns a Report" do
      report = described_class.new(session_with("good practice")).analyze
      expect(report).to be_a(DanceCop::Report)
    end

    it "returns a clean report when no offenses match" do
      report = described_class.new(session_with("great session, feeling confident")).analyze
      expect(report).to be_clean
    end

    it "detects offenses from matching notes" do
      report = described_class.new(session_with("rushed the basic step")).analyze
      expect(report).not_to be_clean
    end

    context "with a specific rule injected" do
      it "only runs the injected rule" do
        report = described_class.new(
          session_with("frame collapsed"),
          rules: [DanceCop::Rules::FrameCop]
        ).analyze

        expect(report.map(&:category)).to all(eq("Frame"))
      end
    end

    it "accumulates offenses from multiple rules" do
      notes = "rushed the basic step and frame collapsed"
      report = described_class.new(session_with(notes)).analyze
      categories = report.map(&:category)
      expect(categories).to include("Timing", "Frame")
    end
  end
end
