# frozen_string_literal: true

require 'spec_helper'

RSpec.describe '.rubocop_rules.yml' do # rubocop:disable RSpec/DescribeClass
  it 'has the rules' do
    # Write rubocop_rules.yml
    `bin/lint --write-rubocop-rules`

    # Verify that the file hasn't changed
    expect(`git diff --exit-code .rubocop_rules.yml`).to eq('')
  end
end
