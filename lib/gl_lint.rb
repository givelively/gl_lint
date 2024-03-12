require 'gl_lint/cli'
require 'gl_lint/file_selector'
require 'gl_lint/linter'
require 'gl_lint/export_rubocop'

module GlLint
  class << self
    def call_cli(app_root:, linters: nil)
      options = GlLint::CLI.parse(app_root:, linters:)
      puts 'Options: ', options, '' if options[:verbose]

      call(**options.except(:verbose))
    end

    def call(app_root:, write_rubocop_rules:, no_fix:, list_only:, unsafe_fix:, linters:, target_files:, filenames:,
             default_target:)
      Dir.chdir(app_root) do
        if write_rubocop_rules
          GlLint::ExportRubocop.write_rules(app_root)
        else
          lint_strategy = lint_strategy_from_options(no_fix:, list_only:, unsafe_fix:)
          GlLint::Linter.new.lint(linters:, target_files:, filenames:, lint_strategy:)
        end
      end
    end

    private

    def lint_strategy_from_options(no_fix: false, list_only: false, unsafe_fix: false)
      return :list_only if list_only
      return :no_fix if no_fix

      unsafe_fix ? :unsafe_fix : :fix
    end
  end
end
