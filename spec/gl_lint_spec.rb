require 'spec_helper'

RSpec.describe GlLint do
  let(:app_root) { Dir.pwd }

  describe 'call_cli' do
    before do
      @original_argv = ARGV.dup # Save the original ARGV
      ARGV.replace(passed_args)
    end

    after { ARGV.replace(@original_argv) }

    let(:passed_args) { ['--list-files', '--unsafe-fix'] }

    it 'parses the options' do
      expect_any_instance_of(GlLint::Linter).to receive(:lint).with(linters: %w[rubocop prettier],
                                                                    target_files: '--changed', filenames: nil, lint_strategy: :list_only)
      described_class.call_cli(app_root:)
    end

    context 'with a filename' do
      let(:passed_args) { ['--no-fix', 'spec/gl_lint_spec.rb'] }

      it 'parses the options' do
        expect_any_instance_of(GlLint::Linter).to receive(:lint).with(linters: %w[rubocop prettier],
                                                                      target_files: '--changed', filenames: ['spec/gl_lint_spec.rb'], lint_strategy: :no_fix)
        described_class.call_cli(app_root:)
      end
    end

    context 'with write-rubocop-rules' do
      let(:passed_args) { ['--no-fix', '--write-rubocop-rules'] }

      it 'parses the options' do
        expect(GlLint::ExportRubocop).to receive(:write_rules).with(app_root)
        described_class.call_cli(app_root:)
      end
    end
  end
end
