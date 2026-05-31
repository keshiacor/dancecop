# frozen_string_literal: true

RSpec.describe DanceCop::Rules::BalanceCop do
  def analyze(notes)
    session = DanceCop::PracticeSession.new(notes: notes)
    DanceCop::Analyzer.new(session, rules: [described_class]).analyze
  end

  it "detects flat-footed stepping" do
    report = analyze("kept landing flat-footed and heavy")
    expect(report.map(&:rule_name)).to include("WeightTransfer")
  end

  it "detects balance issues during turns" do
    report = analyze("keep falling out of turns, especially on the right")
    expect(report.map(&:rule_name)).to include("Turns")
  end

  it "detects wobbling" do
    report = analyze("wobbling after each turn sequence")
    expect(report.map(&:rule_name)).to include("Turns")
  end

  it "detects core engagement issues" do
    report = analyze("feeling unstable through the center")
    expect(report.map(&:rule_name)).to include("Core")
  end

  it "returns no offenses for balanced notes" do
    report = analyze("great stability today, turns were crisp")
    expect(report).to be_clean
  end

  it "assigns Balance as the category" do
    report = analyze("flat-footed")
    expect(report.map(&:category)).to all(eq("Balance"))
  end
end
