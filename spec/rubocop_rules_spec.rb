# frozen_string_literal: true

require 'spec_helper'

RSpec.describe '.rubocop_rules.yml' do # rubocop:disable RSpec/DescribeClass
  it 'has the rules' do
    require 'gl_lint'

    # Write rubocop_rules.yml
    GlLint.call(app_root: Dir.pwd, write_rubocop_rules: true)

    # Verify that the file hasn't changed
    expect(`git diff --exit-code .rubocop_rules.yml`).to eq('')
  end
end
