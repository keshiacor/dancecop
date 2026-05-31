# DanceCop 💃

> RuboCop for your dance practice.

DanceCop analyzes salsa and bachata practice notes and generates structured
coaching feedback — offenses, focus areas, and suggested drills — modeled
directly on how RuboCop analyzes Ruby code.

Built as a RubyConf scholar project to demonstrate that Ruby's philosophy of
feedback, conventions, readability, and continuous improvement applies far
beyond code.

---

## Installation

Add to your Gemfile:

```ruby
gem "dancecop"
```

Or install directly:

```bash
gem install dancecop
```

Requires Ruby 3.2+.

---

## Usage

### CLI

Write your practice notes in a plain text file:

```text
# notes.txt

Really struggled with timing today. Rushed the basic step constantly
and kept going behind the beat during the mambo section.

Frame was also an issue — instructor mentioned my frame collapsed
during turns and that I need to stop looking down at my feet.

Instructor feedback: stop anticipating the patterns.
```

Then run:

```bash
dancecop analyze notes.txt
```

Output:

```
DanceCop Report
===============

Timing/BasicStep
  Off beat tendency detected

Timing/RhythmConsistency
  Rhythm consistency issues detected

Frame/Posture
  Frame instability detected — upper body structure needs attention

Frame/HeadPosition
  Head position breaking frame alignment

Connection/Follow
  Follow anticipating signals — wait for the lead to complete

5 offenses detected

Recommended Focus:
  Timing
  Frame
  Connection

Suggested Drills:
  - Basic step with metronome — start at 60 BPM, increase by 5
  - Clave pattern isolation: clap the clave, then add footwork
  - Wall frame drill: maintain contact with wall while stepping side-to-side
  - Eyes-up basic: practice basics with gaze fixed at partner eye level
  - Blindfolded follow exercise: close eyes, respond only to physical cues
```

### Ruby DSL

DanceCop also ships a structured practice DSL:

```ruby
require "dancecop"

report = DanceCop.practice do
  style :salsa

  issue "Rushed the basic step"
  issue "Lost timing during cross body leads"
  issue "Frame collapsed during turns"

  instructor_feedback "Keep elbows up"
  instructor_feedback "Wait longer before initiating turns"
end

puts report
```

Because `Report` includes `Enumerable`, you can query results directly:

```ruby
report.count                                    # => 5
report.any?                                     # => true
report.map(&:category)                          # => ["Timing", "Frame", "Connection", ...]
report.group_by(&:category)                     # group offenses by area
report.select { |o| o.severity == :error }
```

---

## Architecture

DanceCop is built from clean, composable objects — no Rails, no unnecessary
dependencies, no magic.

```
DanceCop::PracticeSession   # input boundary — holds notes + instructor feedback
DanceCop::Analyzer          # orchestrator — runs all rules, returns a Report
DanceCop::Rule              # abstract base — rules register themselves via inherited
DanceCop::Offense           # immutable value object — a detected issue (Data.define)
DanceCop::Coach             # converts offenses into prioritized recommendations
DanceCop::Report            # Enumerable + Comparable collection of offenses
DanceCop::SessionBuilder    # powers the DanceCop.practice { } DSL
```

### Rules / Cops

| Rule | Category | Detects |
|---|---|---|
| `TimingCop` | Timing | Rushing, off-beat tendency, rhythm consistency, musicality |
| `FrameCop` | Frame | Frame collapse, elbow position, head alignment, posture |
| `ConnectionCop` | Connection | Excessive force, back-leading, arm tension, CBL breakdown |
| `BalanceCop` | Balance | Flat-footed stepping, turn instability, core engagement |

### Adding a custom rule

Subclass `DanceCop::Rule` and implement `#inspect`. The rule registers itself
automatically — no configuration needed.

```ruby
module DanceCop
  module Rules
    class FootworkCop < Rule
      category "Footwork"
      description "Detects footwork and styling issues"

      PATTERNS = {
        Cucarachas: {
          keywords: ["cucaracha", "side step timing", "weight not shifting"],
          message: "Cucaracha weight transfer incomplete",
          drill: "Slow cucarachas against a wall, full weight shift each rep"
        }
      }.freeze

      def inspect
        PATTERNS.filter_map do |rule_name, pattern|
          next unless keyword_match?(pattern[:keywords])
          offense(rule_name: rule_name.to_s, message: pattern[:message], drill: pattern[:drill])
        end
      end
    end
  end
end
```

That's the whole rule. Require it alongside the gem and it will appear in
every subsequent analysis run.

---

## Design Highlights

DanceCop was built to showcase idiomatic Ruby 3.x patterns:

**`Data.define` for immutable value objects**
`Offense` uses Ruby 3.2's `Data.define` — every offense is frozen at
creation, structurally equal to another with identical fields, and has no
setters. An offense is a fact, and facts don't mutate.

**`inherited` hook for zero-config rule registration**
When any class inherits from `Rule`, Ruby calls `inherited` on the parent.
DanceCop uses this to push the subclass into a shared registry. Writing a
rule registers it automatically — the same pattern used by ActiveRecord,
RuboCop, and RSpec.

**`include Enumerable` on `Report`**
`Report` implements `each` and includes `Enumerable`, giving callers
`count`, `any?`, `select`, `group_by`, `min_by`, and the rest of the
standard library for free.

**`instance_eval` DSL**
`DanceCop.practice { }` evaluates the block in the context of a
`SessionBuilder`, making the block keywords (`style`, `issue`,
`instructor_feedback`) read as domain vocabulary rather than Ruby syntax.

**Dependency injection for testability**
`Analyzer.new(session, rules: [TimingCop])` scopes a run to a single
rule without touching the global registry — the right path is the easy path.

---

## Future Direction

The architecture is designed so AI coaching can be added later without
touching the detection layer:

```ruby
# Planned — not yet implemented
class DanceCop::LLMCoach < DanceCop::Coach
  def suggested_drills
    ClaudeProvider.new.complete(prompt_from(@offenses))
  end
end

DanceCop::Analyzer.new(session, coach: DanceCop::LLMCoach.new).analyze
```

Planned providers: `DanceCop::ClaudeProvider`, `DanceCop::OpenAIProvider`.

---

## Development

```bash
git clone https://github.com/keshia/dancecop
cd dancecop
bundle install

bundle exec rspec          # run the test suite
bundle exec standardrb     # lint
bundle exec ruby bin/dancecop analyze examples/notes.txt
```

---

## Contributing

Bug reports and pull requests are welcome. For new cops, open an issue first
to discuss the detection pattern and keyword set before implementing.

---

## License

MIT. See [LICENSE](LICENSE).

---

## About

Built by [Keshia](https://github.com/keshia) as a RubyConf scholar project.

*"Salsa is for the person you're dancing with. Ruby is for the person reading
your code. Both ask you to let go of ego, trust the conventions, and make the
experience feel effortless for someone else."*
