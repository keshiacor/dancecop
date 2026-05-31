# frozen_string_literal: true

RSpec.describe DanceCop::PracticeSession do
  describe "#all_text" do
    it "combines notes and instructor feedback into one lowercase string" do
      session = described_class.new(
        notes: "Rushed the basic step",
        instructor_feedback: ["Keep ELBOWS up", "Wait longer"]
      )

      text = session.all_text
      expect(text).to include("rushed the basic step")
      expect(text).to include("keep elbows up")
      expect(text).to include("wait longer")
    end

    it "handles empty instructor feedback" do
      session = described_class.new(notes: "Good session today")
      expect(session.all_text).to eq("good session today")
    end
  end

  describe "#empty?" do
    it "returns true when notes and feedback are blank" do
      expect(described_class.new(notes: "")).to be_empty
    end

    it "returns false when notes are present" do
      expect(described_class.new(notes: "Worked on turns")).not_to be_empty
    end
  end

  describe "immutability" do
    it "is frozen after initialization" do
      session = described_class.new(notes: "test")
      expect(session).to be_frozen
    end

    it "freezes the instructor_feedback array" do
      session = described_class.new(notes: "test", instructor_feedback: ["keep frame up"])
      expect(session.instructor_feedback).to be_frozen
    end
  end

  describe "style" do
    it "accepts a style symbol" do
      session = described_class.new(notes: "test", style: :salsa)
      expect(session.style).to eq(:salsa)
    end

    it "defaults to nil" do
      session = described_class.new(notes: "test")
      expect(session.style).to be_nil
    end
  end
end
