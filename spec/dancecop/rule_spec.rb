# frozen_string_literal: true

RSpec.describe DanceCop::Rule do
  describe "auto-registration via inherited hook" do
    it "registers all rule subclasses" do
      expect(described_class.registry).to include(
        DanceCop::Rules::TimingCop,
        DanceCop::Rules::FrameCop,
        DanceCop::Rules::ConnectionCop,
        DanceCop::Rules::BalanceCop
      )
    end

    it "registers a new rule class when defined" do
      test_cop = Class.new(described_class)
      expect(described_class.registry).to include(test_cop)
      described_class.registry.delete(test_cop)
    end
  end

  describe ".category DSL" do
    it "infers category by stripping Cop suffix from class name" do
      # Anonymous class with a fake #name — no registry pollution since
      # we remove it immediately and it never gets an #inspect method.
      klass = Class.new(described_class) { def self.name = "DanceCop::Rules::FootworkCop" }
      described_class.registry.delete(klass)
      expect(klass.category).to eq("Footwork")
    end

    it "uses the explicitly declared category" do
      expect(DanceCop::Rules::TimingCop.category).to eq("Timing")
    end
  end

  describe "#inspect" do
    it "raises NotImplementedError on the base class" do
      session = DanceCop::PracticeSession.new(notes: "test")
      rule = described_class.allocate
      rule.instance_variable_set(:@session, session)
      expect { rule.inspect }.to raise_error(NotImplementedError)
    end
  end
end
