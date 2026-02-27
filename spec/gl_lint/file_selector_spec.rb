require 'spec_helper'

RSpec.describe GLLint::FileSelector do
  describe 'files' do
    context 'with filenames' do
      let(:filenames) { ['packs/metrics/spec/record_metric_spec.rb'] }
      let(:target) { { rubocop: filenames, eslint: [], herb: [] } }

      it 'returns filenames' do
        expect(described_class.files(filenames:)).to eq({ rubocop: filenames, eslint: [],
                                                          herb: [] })
      end

      context 'with schema.rb' do
        let(:filenames) do
          ['packs/metrics/spec/record_metric_spec.rb', 'db/schema.rb', 'db/analytics_schema.rb',
           'Gemfile', 'Gemfile.lock']
        end
        let(:target_filenames) { ['packs/metrics/spec/record_metric_spec.rb', 'Gemfile'] }
        let(:target) { { rubocop: target_filenames, eslint: [], herb: [] } }

        it 'returns filenames' do
          expect(described_class.files(filenames:)).to eq target
        end
      end

      context 'with full filename' do
        let(:filenames) do
          ['/Users/givelively/charity-api/packs/metrics/spec/record_metric_spec.rb',
           '/Users/givelively/charity-api/Gemfile']
        end

        it 'returns filenames' do
          expect(described_class.files(filenames:)).to eq target
        end
      end
    end

    context 'with eslint and herb files' do
      let(:filenames) do
        %w[app/components/body_text/component.html.erb
           app/views/nonprofit_mailer/in_review.html.erb
           app/components/menu/component_controller.js
           frontend/cart-client.js
           app/models/salesforce_external_sync.rb
           app/components/smart_donations/applied_nonprofit_banner/component.html.haml]
      end
      let(:target) { { rubocop: filenames[4..5], eslint: filenames[2..3], herb: filenames[0..1] } }

      it 'returns filenames' do
        expect(described_class.files(filenames:)).to eq target
      end
    end

    context 'with target_files' do
      it 'returns nil' do
        expect(described_class.files(target_files: '--all')).to eq({ rubocop: nil, eslint: nil,
                                                                     herb: nil })
      end
    end
  end
end
