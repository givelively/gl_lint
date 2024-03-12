require 'spec_helper'

RSpec.describe GlLint do
  let(:app_root) { Dir.pwd }

  describe 'call_cli' do
    it 'parses the options' do
      allow($stdin).to receive(:gets) { "--list-files --unsafe-fix" }
      expect_any_instance_of(GlLint::Linter).to receive(:lint).with(linters: [:rubocop], target_files: '--changed', filenames: '', lint_strategy: :list_only)
      # Object.stub_const(:ARGV, "--list-files --unsafe-fix") do
      GlLint.call_cli(app_root:)
      # end
    end
  end
end
