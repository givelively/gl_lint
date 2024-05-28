# frozen_string_literal: true

require 'English'
lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'g_l_lint/version'

NON_GEM_FILES = ['Gemfile', 'Gemfile.lock', 'Guardfile', 'bin/lint'].freeze

Gem::Specification.new do |spec|
  spec.name = 'g_l_lint'
  spec.version = GLLint::VERSION
  spec.authors = ['Give Lively']
  spec.summary = 'Give Lively linter tool'
  spec.homepage = 'https://github.com/givelively/g_l_lint'
  spec.license = 'Apache'
  spec.platform = Gem::Platform::RUBY

  spec.required_ruby_version = '>= 3.1'

  spec.extra_rdoc_files = ['README.md']

  spec.files = `git ls-files`
               .split($INPUT_RECORD_SEPARATOR).grep_v(/^(spec|\.)/) - NON_GEM_FILES
  spec.require_paths = ['lib']

  spec.add_dependency 'optparse'
  spec.add_dependency 'rubocop'
  spec.add_dependency 'rubocop-performance'
  spec.add_dependency 'rubocop-rake'
  spec.add_dependency 'rubocop-rspec'

  spec.metadata['rubygems_mfa_required'] = 'true'
end
