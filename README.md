# Give Lively Lint

Linting tool.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gl_lint', require: false
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install gl_lint

## Usage

Create a an executable `bin/lint` file with:

`touch bin/lint && chmod 755 bin/lint`

Then add this to the file:

```ruby
#!/usr/bin/env ruby
require 'bundler/setup'
require 'gl_lint'

GlLint.run_cli(app_root: File.expand_path('..', __dir__))
```

Then run `bin/lint` to lint your changes

Alternatively, if your project doesn't have JavaScript, add `linters: ['rubocop]`

```ruby
GlLint.run_cli(app_root: File.expand_path('..', __dir__),
               linters: ['rubocop'])
```

## Publishing gem to rubygems!

[Build the gem](http://guides.rubygems.org/make-your-own-gem/)

    gem build gl_lint.gemspec

[Push to rubygems](http://guides.rubygems.org/publishing/)

    gem push gl_lint-0.2.0.gem
