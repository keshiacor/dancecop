# frozen_string_literal: true

RSpec.describe DanceCop::Rules::TimingCop do
  def analyze(notes)
    session = DanceCop::PracticeSession.new(notes: notes)
    DanceCop::Analyzer.new(session, rules: [described_class]).analyze
  end

  it "detects off-beat tendency from 'rushed'" do
    report = analyze("I rushed the basic step today")
    expect(report.map(&:rule_name)).to include("BasicStep")
  end

  it "detects off-beat tendency from 'behind the beat'" do
    report = analyze("Kept landing behind the beat")
    expect(report.map(&:rule_name)).to include("BasicStep")
  end

  it "detects rhythm consistency issues from 'lost timing'" do
    report = analyze("I lost timing during the pattern")
    expect(report.map(&:rule_name)).to include("RhythmConsistency")
  end

  it "detects musicality issues from 'musicality'" do
    report = analyze("Need to work on my musicality")
    expect(report.map(&:rule_name)).to include("Musicality")
  end

  it "returns no offenses for clean timing notes" do
    report = analyze("Really locked in today, felt every beat")
    expect(report).to be_clean
  end

  it "detects multiple timing issues in one session" do
    report = analyze("Rushed the basic and completely lost timing on the combination")
    rule_names = report.map(&:rule_name)
    expect(rule_names).to include("BasicStep", "RhythmConsistency")
  end

  it "assigns Timing as the category" do
    report = analyze("rushed")
    expect(report.map(&:category)).to all(eq("Timing"))
  end

  it "includes a suggested drill" do
    report = analyze("rushed the step")
    expect(report.first.drill).not_to be_nil
  end
end
