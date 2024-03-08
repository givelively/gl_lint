require 'spec_helper'

RSpec.describe GlLint::ExportRubocop do
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
  end
end
