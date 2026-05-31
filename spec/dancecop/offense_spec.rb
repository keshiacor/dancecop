# frozen_string_literal: true

RSpec.describe DanceCop::Offense do
  subject(:offense) do
    described_class.new(
      rule_name: "BasicStep",
      category: "Timing",
      message: "Off beat tendency detected",
      drill: "Basic step with metronome"
    )
  end

  describe "immutability" do
    it "is frozen at creation" do
      expect(offense).to be_frozen
    end

    it "does not allow mutation" do
      expect { offense.instance_variable_set(:@message, "changed") }.to raise_error(FrozenError)
    end
  end

  describe "value semantics" do
    it "equals another offense with identical fields" do
      duplicate = described_class.new(
        rule_name: "BasicStep",
        category: "Timing",
        message: "Off beat tendency detected",
        drill: "Basic step with metronome"
      )
      expect(offense).to eq(duplicate)
    end

    it "is not equal to an offense with different fields" do
      different = described_class.new(
        rule_name: "Posture",
        category: "Frame",
        message: "Frame instability"
      )
      expect(offense).not_to eq(different)
    end
  end

  describe "defaults" do
    it "defaults severity to :warning" do
      expect(offense.severity).to eq(:warning)
    end

    it "defaults drill to nil" do
      minimal = described_class.new(rule_name: "X", category: "Y", message: "Z")
      expect(minimal.drill).to be_nil
    end
  end

  describe "#to_s" do
    it "formats as Category/RuleName followed by message" do
      expect(offense.to_s).to eq("Timing/BasicStep\n  Off beat tendency detected")
    end
  end

  describe "severity predicates" do
    it "returns true for #warning? when severity is :warning" do
      expect(offense).to be_warning
    end

    it "returns false for #error? when severity is :warning" do
      expect(offense).not_to be_error
    end

    it "identifies errors correctly" do
      error_offense = described_class.new(
        rule_name: "X", category: "Y", message: "Z", severity: :error
      )
      expect(error_offense).to be_error
    end
  end
end
