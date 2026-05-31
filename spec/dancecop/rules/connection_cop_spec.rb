# frozen_string_literal: true

RSpec.describe DanceCop::Rules::ConnectionCop do
  def analyze(notes)
    session = DanceCop::PracticeSession.new(notes: notes)
    DanceCop::Analyzer.new(session, rules: [described_class]).analyze
  end

  it "detects excessive force in the lead" do
    report = analyze("I was using too much force when leading")
    expect(report.map(&:rule_name)).to include("Lead")
  end

  it "detects forcing from 'yanking'" do
    report = analyze("Partner said I was yanking them into turns")
    expect(report.map(&:rule_name)).to include("Lead")
  end

  it "detects follow anticipation issues" do
    report = analyze("I kept anticipating the next move instead of following")
    expect(report.map(&:rule_name)).to include("Follow")
  end

  it "detects arm tension" do
    report = analyze("arms were too tense throughout")
    expect(report.map(&:rule_name)).to include("Tension")
  end

  it "detects cross body lead breakdown" do
    report = analyze("lost connection on cross body lead every time")
    expect(report.map(&:rule_name)).to include("CrossBodyLead")
  end

  it "returns no offenses for clean connection notes" do
    report = analyze("connection felt elastic and responsive today")
    expect(report).to be_clean
  end

  it "assigns Connection as the category" do
    report = analyze("too much force")
    expect(report.map(&:category)).to all(eq("Connection"))
  end
end
