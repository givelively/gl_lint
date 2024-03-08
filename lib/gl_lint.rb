require_relative '../lib/cli_parser'
require_relative '../lib/file_selector'
require_relative '../lib/linter'
require_relative '../lib/export_rubocop'

module GlLint
  class << self
    def lint_strategy_from_options(no_fix: false, list_only: false, unsafe_fix: false)
      return :list_only if list_only
      return :no_fix if no_fix

      unsafe_fix ? :unsafe_fix : :fix
    end

    def run_cli(app_root:, linters: nil)
      options = GlLint::CLI.parse(app_root:, linters:)
      puts 'Options: ', options, '' if options[:verbose]

      Dir.chdir(options[:app_root]) do
        if options[:write_rubocop_rules]
          GlLint::ExportRubocop.write_rules(app_root)
        else
          lint_strategy = lint_strategy_from_options(**options.slice(:no_fix, :list_only,
                                                                     :unsafe_fix))
          linter_args = options.slice(:linters, :target_files, :filenames)
                               .merge(lint_strategy:)
          GlLint::Linter.new.lint(**linter_args)
        end
      end
    end
  end
end
