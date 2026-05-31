# frozen_string_literal: true

RSpec.describe DanceCop::SessionBuilder do
  describe "#build" do
    it "builds a PracticeSession from issues" do
      builder = described_class.new
      builder.issue("Rushed the basic step")
      builder.issue("Lost timing on CBL")

      session = builder.build
      expect(session.all_text).to include("rushed the basic step")
      expect(session.all_text).to include("lost timing on cbl")
    end

    it "includes instructor feedback in the session" do
      builder = described_class.new
      builder.instructor_feedback("Keep elbows up")

      session = builder.build
      expect(session.instructor_feedback).to include("Keep elbows up")
    end

    it "sets the style" do
      builder = described_class.new
      builder.style(:salsa)

      expect(builder.build.style).to eq(:salsa)
    end
  end

  describe "DanceCop.practice DSL" do
    it "returns a Report from a practice block" do
      report = DanceCop.practice do
        style :salsa
        issue "Rushed the basic step"
      end

      expect(report).to be_a(DanceCop::Report)
    end

    it "detects offenses from DSL-provided issues" do
      report = DanceCop.practice do
        issue "frame collapsed completely"
      end

      expect(report).not_to be_clean
      expect(report.map(&:category)).to include("Frame")
    end

    it "detects offenses from instructor feedback" do
      report = DanceCop.practice do
        issue "good session overall"
        instructor_feedback "keep elbows up next time"
      end

      categories = report.map(&:category)
      expect(categories).to include("Frame")
    end

    it "returns a clean report when no issues are detected" do
      report = DanceCop.practice do
        issue "great session, everything clicked"
      end

      expect(report).to be_clean
    end

    it "supports method chaining on the builder" do
      builder = described_class.new
      result = builder.style(:bachata).issue("Rushed").instructor_feedback("Slow down")
      expect(result).to be(builder)
    end
  end
end
