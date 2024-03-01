# frozen_string_literal: true

require File.expand_path('lib/gl/lint/version', __dir__)

Gem::Specification.new do |spec|
  spec.name = 'gl-lint'
  spec.version = GL::Lint::VERSION
  spec.authors = ['Give Lively']
  spec.summary = 'Give Lively linter'
  spec.homepage = 'https://github.com/givelively/gl-lint'
  spec.license = 'Apache'
  spec.platform = Gem::Platform::RUBY

  spec.required_ruby_version = '>= 3.0.0'
  spec.extra_rdoc_files = ['README.md']
  spec.files = Dir['LICENSE', 'lib/**/*.rb']
  spec.require_paths = ['lib']
  
  spec.add_dependency 'optparse'
  spec.add_dependency 'rubocop'

  spec.metadata['rubygems_mfa_required'] = 'true'
end
