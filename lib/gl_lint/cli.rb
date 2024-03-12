require 'optparse'

module GlLint
  class CLI
    LINTERS = %w[rubocop prettier].freeze
    DEFAULT_TARGET = '--changed'.freeze

    TARGET_FILE_OPTS = [
      ['--changed', '-c', 'Lints uncommitted changes (default)'],
      ['--staged', '-s', 'Lints only staged files'],
      ['--branch', '-b', 'Lints any files changed in the branch'],
      ['--all', '-a', 'Lints all files']
    ].freeze

    class << self
      # Disabling metrics, it doesn't make sense to deconstruct the CLI parser
      # rubocop:disable Metrics
      def parse(app_root:, linters: nil, default_target: nil, options: {})
        options = default_options(linters:, app_root:, default_target:).merge(options)

        OptionParser.new do |parser|
          TARGET_FILE_OPTS.each do |args|
            parser.on(*args) do
              raise "You can't pass multiple 'target files' options!" if options[:target_files]

              options[:target_files] = args.first
            end
          end

          parser.on('--rubocop', 'Lints only with rubocop') do
            raise "This project doesn't support rubocop" unless LINTERS.include?('rubocop')

            options[:linters] = ['rubocop']
          end

          parser.on('--prettier', 'Lints only with prettier') do
            raise "This project doesn't support rubocop" unless LINTERS.include?('prettier')
            raise "You can't pass both --rubocop and --prettier" if options[:linters] == ['rubocop']

            options[:linters] = ['prettier']
          end

          parser.on('--no-fix', 'Does not auto-fix') do
            options[:no_fix] = true
          end

          parser.on('--unsafe-fix',
                    'Rubocop fixes with unsafe option (also can be set with UNSAFE=true)') do
            options[:unsafe_fix] = true
          end

          parser.on('--list-files', 'Prints out files that would be linted (dry run)') do
            options[:list_only] = true
          end

          parser.on('--verbose', 'Prints out all options') do
            options[:verbose] = true
          end

          parser.on('--write-rubocop-rules', 'Updates .rubocop_rules.yml') do
            options[:write_rubocop_rules] = true
          end

          parser.on_tail('-h', '--help', 'Show this message') do
            puts parser
            puts "\nExamples:"
            puts '    bin/lint                         -- Lints uncommitted changes (default)'
            puts '    bin/lint --branch                -- Lints files changed on current branch'
            puts "    bin/lint spec/rails_helper.rb    -- Lints 'spec/rails_helper.rb'"
            puts ''
            exit
          end
        end.parse!

        # Enable passing in filenames to lint
        if ARGV.any?
          options[:filenames] = ARGV
          puts "passed files: #{options[:filenames]}"

          raise "Passed both 'filenames' and 'target files': #{options[:target_files]}" if options[:target_files]
        end
        options[:target_files] ||= options[:default_target]
        options
      end
      # rubocop:enable Metrics

      private

      def default_options(linters:, app_root:, default_target:)
        {
          app_root:,
          default_target: default_target || DEFAULT_TARGET,
          filenames: nil,
          linters: linters || LINTERS,
          list_only: false,
          no_fix: false,
          unsafe_fix: ENV['UNSAFE_LINT'] == 'true',
          verbose: false,
          write_rubocop_rules: false
        }
      end
    end
  end
end
