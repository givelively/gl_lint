module GLLint
  class FileSelector
    NON_RB_RUBY_FILES = %w[Gemfile Rakefile config.ru .erb
                           bin/bundle bin/lint bin/rubocop bin/setup bin/update].freeze

    class << self
      def files(filenames: nil, target_files: nil)
        selected_files = filenames || filenames_from_target_files(target_files)

        if selected_files
          rubocop_files = selected_files.grep(/\.(rb|rake|gemspec)\z/)
          rubocop_files += selected_files.select { |f| f.end_with?(*NON_RB_RUBY_FILES) }
          # Make certain that schemas are ignored
          rubocop_files.reject! { |f| f.match?(%r{db/.*schema.rb}) }

          eslint_files = selected_files.grep(/\.(js|jsx|css)\z/)
        end

        { rubocop: rubocop_files, eslint: eslint_files }
      end

      private

      def filenames_from_target_files(target_files)
        case target_files
        when '--branch' then files_changed_on_branch
        when '--staged' then files_staged
        when '--all' then return nil
        when '--changed' then files_changed_currently
        else
          raise 'Unknown target files!'
        end.map { |s| parse_git_output(s) }.compact
      end

      def files_changed_currently
        # Get just the filenames of the changed files
        `git status -s`.split("\n")
      end

      def files_staged
        # staged files have the change as the first character
        `git status -s`.split("\n").select { |s| s.start_with?(/^\w/) }
      end

      def files_changed_on_branch
        branch = `git symbolic-ref --short HEAD`.strip
        main_branch = 'origin/main' # We need to use origin/main or the github action fails
        puts "linting changed files between '#{main_branch}' > '#{branch}'\n\n"
        `git diff --merge-base --name-status #{main_branch} #{branch}`.split("\n")
      end

      def parse_git_output(str)
        # Return nil if the file is deleted
        return nil if str.start_with?(/\s?D\s/)

        if str.match?(/^R/)
          # If renamed, grab the renamed filename (which is the second filenamename in the list)
          str.split(/(->)|(\t+)/).last
        else
          # Otherwise just grab the filename
          str.gsub(/^\s?\S\S?\s+/, '')
        end.strip
      end
    end
  end
end
