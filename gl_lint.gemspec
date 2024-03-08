# frozen_string_literal: true

require 'English'
lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gl_lint/version'

Gem::Specification.new do |spec|
  spec.name = 'gl_lint'
  spec.version = GlLint::VERSION
  spec.authors = ['Give Lively']
  spec.summary = 'Give Lively linter tool'
  spec.homepage = 'https://github.com/givelively/gl_lint'
  spec.license = 'Apache'
  spec.platform = Gem::Platform::RUBY

  spec.required_ruby_version = '>= 3.1'

  spec.extra_rdoc_files = ['README.md']

  spec.files = `git ls-files`.split($INPUT_RECORD_SEPARATOR).grep_v(/^(spec|\.)/)
  spec.require_paths = ['lib']

  spec.add_dependency 'optparse'
  spec.add_dependency 'rubocop'
  spec.add_dependency 'rubocop-performance'
  spec.add_dependency 'rubocop-rake'
  spec.add_dependency 'rubocop-rspec'

  spec.metadata['rubygems_mfa_required'] = 'true'
end
