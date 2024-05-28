require 'spec_helper'

RSpec.describe GLLint do
  let(:app_root) { Dir.pwd }

  describe 'call_cli' do
    before do
      @original_argv = ARGV.dup # Save the original ARGV
      ARGV.replace(passed_args)
    end

    after { ARGV.replace(@original_argv) } # rubocop:disable RSpec/InstanceVariable

    let(:passed_args) { ['--list-files', '--unsafe-fix'] }

    it 'parses the options' do
      expect_any_instance_of(GLLint::Linter).to receive(:lint).with(linters: %w[rubocop prettier],
                                                                    target_files: '--changed',
                                                                    filenames: nil,
                                                                    lint_strategy: :list_only)
      described_class.call_cli(app_root:)
    end

    context 'with default_target and linters' do
      let(:passed_args) { [] }

      it 'uses the defaults the options' do
        ENV['UNSAFE_LINT'] = 'true'
        expect_any_instance_of(GLLint::Linter).to receive(:lint).with(linters: %w[rubocop],
                                                                      target_files: '--all',
                                                                      filenames: nil,
                                                                      lint_strategy: :unsafe_fix)
        described_class.call_cli(app_root:, default_target: '--all', linters: 'rubocop')
      end
    end

    context 'with a filename' do
      let(:passed_args) { ['--no-fix', 'spec/g_l_lint_spec.rb'] }

      it 'parses the options' do
        expect_any_instance_of(GLLint::Linter).to receive(:lint).with(linters: %w[rubocop prettier],
                                                                      target_files: '--changed',
                                                                      filenames: ['spec/g_l_lint_spec.rb'],
                                                                      lint_strategy: :no_fix)
        described_class.call_cli(app_root:)
      end
    end

    context 'with write-rubocop-rules' do
      let(:passed_args) { ['--no-fix', '--write-rubocop-rules'] }

      it 'parses the options' do
        expect(GLLint::ExportRubocop).to receive(:write_rules).with(app_root)
        described_class.call_cli(app_root:)
      end
    end
  end
end
