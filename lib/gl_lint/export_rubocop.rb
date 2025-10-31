require 'yaml'

module GLLint
  class ExportRubocop
    class << self
      IGNORED_PROPERTIES = %w[Description Enabled Reference Safe SafeAutoCorrect
                              StyleGuide SupportedStyles].freeze

      def write_rules(app_root)
        puts "Updating .rubocop_rules.yml - version: #{rubocop_version}"

        enabled_rules = rubocop_rules.map { |arr| stored_rule(app_root, arr) }.compact

        File.write('.rubocop_rules.yml', YAML.dump(enabled_rules.to_h))
      end

      private

      def stored_rule(app_root, arr)
        # Only save enabled rules
        return unless arr[1]['Enabled'] == true

        # Ignore properties which aren't relevant to tracking rule state
        arr[1] = arr[1].except(*IGNORED_PROPERTIES)

        arr[1]['Exclude']&.each { |str| str.gsub!(app_root, '') }

        [arr[0], arr[1]]
      end

      def rubocop_rules
        YAML.safe_load(`rubocop -c .rubocop.yml --show-cops`,
                       permitted_classes: [Regexp, Symbol]).to_a
      end

      def rubocop_version
        `rubocop -V`.strip.split("\n").first.split('[').first.strip.gsub(' running on', '')
      end
    end
  end
end
