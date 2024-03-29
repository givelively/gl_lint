require 'spec_helper'

RSpec.describe GlLint::FileSelector do
  describe 'files' do
    context 'with filenames' do
      let(:filenames) { ['packs/metrics/spec/record_metric_spec.rb'] }

      it 'returns filenames' do
        expect(described_class.files(filenames:)).to eq({ rubocop: filenames, prettier: [] })
      end
    end

    context 'with target_files' do
      it 'returns nil' do
        expect(described_class.files(target_files: '--all')).to eq({ rubocop: nil, prettier: nil })
      end
    end
  end
end
