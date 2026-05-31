# frozen_string_literal: true

RSpec.describe DanceCop::Report do
  let(:session) { DanceCop::PracticeSession.new(notes: "test") }

  def build_offense(category: "Timing", rule_name: "BasicStep", message: "Off beat")
    DanceCop::Offense.new(rule_name: rule_name, category: category, message: message)
  end

  describe "Enumerable interface" do
    it "counts offenses with #count" do
      offenses = [build_offense, build_offense(category: "Frame", rule_name: "Posture")]
      report = described_class.new(session: session, offenses: offenses)
      expect(report.count).to eq(2)
    end

    it "supports #select to filter by category" do
      offenses = [
        build_offense(category: "Timing"),
        build_offense(category: "Frame", rule_name: "Posture", message: "Frame issue")
      ]
      report = described_class.new(session: session, offenses: offenses)
      timing_only = report.select { |o| o.category == "Timing" }
      expect(timing_only.count).to eq(1)
    end

    it "supports #group_by to group by category" do
      offenses = [
        build_offense(category: "Timing"),
        build_offense(category: "Timing", rule_name: "Rhythm", message: "Rhythm issue"),
        build_offense(category: "Frame", rule_name: "Posture", message: "Frame issue")
      ]
      report = described_class.new(session: session, offenses: offenses)
      grouped = report.group_by(&:category)
      expect(grouped["Timing"].length).to eq(2)
      expect(grouped["Frame"].length).to eq(1)
    end
  end

  describe "#clean?" do
    it "returns true when there are no offenses" do
      report = described_class.new(session: session, offenses: [])
      expect(report).to be_clean
    end

    it "returns false when there are offenses" do
      report = described_class.new(session: session, offenses: [build_offense])
      expect(report).not_to be_clean
    end
  end

  describe "#to_s" do
    context "with no offenses" do
      it "includes a positive message" do
        report = described_class.new(session: session, offenses: [])
        expect(report.to_s).to include("No offenses detected")
      end
    end

    context "with offenses" do
      subject(:report) do
        described_class.new(
          session: session,
          offenses: [
            DanceCop::Offense.new(
              rule_name: "BasicStep",
              category: "Timing",
              message: "Off beat tendency detected",
              drill: "Metronome drill"
            )
          ]
        )
      end

      it "includes a DanceCop Report header" do
        expect(report.to_s).to include("DanceCop Report")
      end

      it "includes the offense formatted string" do
        expect(report.to_s).to include("Timing/BasicStep")
        expect(report.to_s).to include("Off beat tendency detected")
      end

      it "includes offense count" do
        expect(report.to_s).to include("1 offense detected")
      end

      it "includes recommended focus areas" do
        expect(report.to_s).to include("Recommended Focus")
        expect(report.to_s).to include("Timing")
      end

      it "includes suggested drills" do
        expect(report.to_s).to include("Suggested Drills")
        expect(report.to_s).to include("Metronome drill")
      end
    end

    it "pluralizes offense count correctly" do
      two_offense_report = described_class.new(
        session: session,
        offenses: [build_offense, build_offense(category: "Frame", rule_name: "P", message: "m")]
      )
      expect(two_offense_report.to_s).to include("2 offenses detected")
    end
  end

  describe "Comparable" do
    it "considers reports with fewer offenses as less than those with more" do
      light = described_class.new(session: session, offenses: [build_offense])
      heavy = described_class.new(
        session: session,
        offenses: [build_offense, build_offense(category: "Frame", rule_name: "P", message: "m")]
      )
      expect(light).to be < heavy
    end
  end
end
