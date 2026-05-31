# frozen_string_literal: true

require_relative "lib/dancecop/version"

Gem::Specification.new do |spec|
  spec.name = "dancecop"
  spec.version = DanceCop::VERSION
  spec.authors = ["Keshia"]
  spec.email = ["keshia@thinkific.com"]

  spec.summary = "A RuboCop-inspired dance practice analyzer"
  spec.description = <<~DESC
    DanceCop analyzes salsa and bachata practice notes and generates
    structured coaching feedback — demonstrating how Ruby's philosophy
    of conventions, feedback, and continuous improvement applies beyond code.
  DESC
  spec.homepage = "https://github.com/keshia/dancecop"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  spec.files = Dir["lib/**/*", "bin/*", "*.gemspec", "LICENSE", "README.md"]
  spec.bindir = "bin"
  spec.executables = ["dancecop"]
  spec.require_paths = ["lib"]

  spec.metadata["rubygems_mfa_required"] = "true"
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"
end
