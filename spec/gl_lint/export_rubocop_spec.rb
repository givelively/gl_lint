require 'spec_helper'

RSpec.describe GLLint::ExportRubocop do
  describe 'stored_rule' do
    let(:app_root) { Dir.pwd }

    context 'with Bundler/DuplicatedGem' do
      let(:input) do
        ['Bundler/DuplicatedGem',
         { 'Description' => 'Checks for duplicate gem entries in Gemfile.',
           'Enabled' => true,
           'Severity' => 'warning',
           'VersionAdded' => '0.46',
           'VersionChanged' => '1.40',
           'Include' => ['**/*.gemfile', '**/Gemfile', '**/gems.rb'] }]
      end
      let(:target) do
        ['Bundler/DuplicatedGem',
         { 'Severity' => 'warning',
           'VersionAdded' => '0.46',
           'VersionChanged' => '1.40',
           'Include' => ['**/*.gemfile', '**/Gemfile', '**/gems.rb'] }]
      end

      it 'returns target' do
        expect(described_class.send(:stored_rule, app_root, input)).to eq target
      end
    end

    context 'with Lint/TopLevelReturnWithArgument' do
      let(:input) do
        ['Lint/TopLevelReturnWithArgument',
         { 'Description' => 'Detects top level return statements with argument.',
           'Enabled' => true,
           'VersionAdded' => '0.89',
           'Exclude' => ["#{app_root}/**/*.jb"] }]
      end
      let(:target) do
        ['Lint/TopLevelReturnWithArgument',
         { 'Exclude' => ['/**/*.jb'],
           'VersionAdded' => '0.89' }]
      end

      it 'returns target' do
        expect(described_class.send(:stored_rule, app_root, input)).to eq target
      end
    end

    context 'with nils' do
      let(:input) do
        ['Layout/FirstHashElementIndentation',
         { 'Description' => 'Checks the indentation of the first key in a hash literal.',
           'Enabled' => true,
           'VersionAdded' => '0.68',
           'VersionChanged' => '0.77',
           'EnforcedStyle' => 'special_inside_parentheses',
           'SupportedStyles' => %w[special_inside_parentheses consistent align_braces],
           'IndentationWidth' => nil }]
      end
      let(:target) do
        ['Layout/FirstHashElementIndentation',
         { 'EnforcedStyle' => 'special_inside_parentheses',
           'IndentationWidth' => nil,
           'VersionAdded' => '0.68',
           'VersionChanged' => '0.77' }]
      end

      it 'returns target' do
        expect(described_class.send(:stored_rule, app_root, input)).to eq target
      end
    end
  end

  context 'with ruby version' do
    rules_ruby_version = '3.2.9' # Update this when the rules are written with a new Ruby version

    # Don't match on patch version
    rules_version_matches = rules_ruby_version.split('.')[0..1] == RUBY_VERSION.split('.')[0..1]

    describe "rubocop_version #{rules_ruby_version}" do
      let(:target) { '1.62.1 (using Parser 3.3.10.0, rubocop-ast 1.47.1, ruby 3.2.9)' }

      it 'returns the target', skip: !rules_version_matches do
        expect(described_class.send(:rubocop_version)).to eq target
      end
    end

    describe 'written_rules' do
      it 'has the rules', skip: !rules_version_matches do
        # Write rubocop_rules.yml
        `bin/lint --write-rubocop-rules`
        # Verify that the file hasn't changed
        expect(`git diff --exit-code --ignore-space-change --unified=0 .rubocop_rules.yml`)
          .to eq('')
      end
    end
  end
end
