# frozen_string_literal: true

RSpec.describe DanceCop::Rules::FrameCop do
  def analyze(notes)
    session = DanceCop::PracticeSession.new(notes: notes)
    DanceCop::Analyzer.new(session, rules: [described_class]).analyze
  end

  it "detects frame collapse" do
    report = analyze("instructor said my frame collapsed during turns")
    expect(report.map(&:rule_name)).to include("Posture")
  end

  it "detects hunching" do
    report = analyze("I kept hunching forward when nervous")
    expect(report.map(&:rule_name)).to include("Posture")
  end

  it "detects elbow issues from instructor feedback" do
    session = DanceCop::PracticeSession.new(
      notes: "good practice overall",
      instructor_feedback: ["keep elbows up at all times"]
    )
    report = DanceCop::Analyzer.new(session, rules: [described_class]).analyze
    expect(report.map(&:rule_name)).to include("Elbows")
  end

  it "detects head position issues" do
    report = analyze("I was looking down at my feet the whole time")
    expect(report.map(&:rule_name)).to include("HeadPosition")
  end

  it "returns no offenses for clean frame notes" do
    report = analyze("frame felt solid, partner said connection was great")
    expect(report).to be_clean
  end

  it "assigns Frame as the category" do
    report = analyze("frame collapsed")
    expect(report.map(&:category)).to all(eq("Frame"))
  end
end
