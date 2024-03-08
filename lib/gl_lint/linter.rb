module GlLint
  class Linter
    attr_accessor :linter_failures

    def lint(linters:, target_files:, lint_strategy:, filenames: nil)
      @linter_failures = []
      files = GlLint::FileSelector.files(filenames:, target_files:)

      lint_ruby_files(linters, target_files, files[:rubocop], lint_strategy)

      lint_prettier_files(linters, target_files, files[:prettier], lint_strategy)

      puts '' # Add some space after printing linting out

      abort(linter_failures.join('\n')) if linter_failures.any?
    end

    private

    def run_linter(*args)
      return if system(*args)

      linter_failures << "\n== Command #{args} failed =="
    end

    def print_files(target_files, files, strategy, linter)
      puts "\n== #{linter} files to lint =="

      if target_files == '--all'
        puts '--all', ''
      elsif files&.none?
        puts "* No #{linter} files to lint! *"
        return :no_lint
      else
        puts files, ''
      end

      return unless strategy == :list_only

      puts 'Run with --list-files, so printing out target files without linting'
      :no_lint
    end

    def lint_ruby_files(linters, target_files, files, strategy)
      return unless linters.include?('rubocop')

      result = print_files(target_files, files, strategy, 'Rubocop')
      return if result == :no_lint

      rubocop_arg = if strategy == :no_fix
                      ''
                    else
                      strategy == :unsafe_fix ? '-A' : '-a'
                    end
      puts '*Rubcop is running in unsafe mode*', '' if rubocop_arg == '-A'
      run_linter(
        'bundle exec rubocop --format quiet -c .rubocop.yml ' \
        "#{rubocop_arg} #{files&.join(' ')}"
      )
    end

    def lint_prettier_files(linters, target_files, files, strategy)
      return unless linters.include?('prettier')

      result = print_files(target_files, files, strategy, 'Prettier')
      return if result == :skip_lint

      # Need to manually call eslint, the package.json script specifies the folders to lint
      prettier_command = strategy == :no_fix ? 'eslint' : 'eslint --fix'
      run_linter("yarn run #{prettier_command} #{files&.join(' ')}")
    end
  end
end
