# frozen_string_literal: true

require "optparse"

module DanceCop
  class CLI
    BANNER = <<~BANNER
      Usage: dancecop <command> [options]

      Commands:
        analyze <file>    Analyze a practice notes file
        version           Print version

      Options:
    BANNER

    def initialize(argv = ARGV)
      @argv = argv.dup
    end

    def run
      command = @argv.shift

      case command
      when "analyze" then cmd_analyze
      when "version", nil then cmd_version
      when "--help", "-h" then print_help
      else
        warn "Unknown command: #{command}"
        print_help
        exit 1
      end
    end

    private

    def cmd_version
      puts "DanceCop #{DanceCop::VERSION}"
    end

    def print_help
      puts build_option_parser
    end

    def cmd_analyze
      file_path = @argv.shift

      if file_path.nil?
        warn "Error: please provide a file path.\n\n  dancecop analyze notes.txt"
        exit 1
      end

      unless File.exist?(file_path)
        warn "Error: file not found — #{file_path}"
        exit 1
      end

      notes = File.read(file_path)
      session = PracticeSession.new(notes: notes)
      report = Analyzer.new(session).analyze

      puts report
      exit report.any? ? 1 : 0
    end

    def build_option_parser
      OptionParser.new do |opts|
        opts.banner = BANNER
        opts.on("-h", "--help", "Show this help") do
          puts opts
          exit
        end
        opts.on("-v", "--version", "Print version") do
          cmd_version
          exit
        end
      end
    end
  end
end
