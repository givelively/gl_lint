# Give Lively Lint

Linting tool.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'g_l_lint', require: false
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install g_l_lint

## Usage

Create a an executable `bin/lint` file with:

`touch bin/lint && chmod 755 bin/lint`

Then add this to the file:

```ruby
#!/usr/bin/env ruby
require 'rubygems'
require 'g_l_lint'

GLLint.call_cli(app_root: File.expand_path('..', __dir__))
```

Then run `bin/lint` to lint your changes

Alternatively, if your project doesn't have JavaScript, add `linters: ['rubocop]`

```ruby
GLLint.call_cli(app_root: File.expand_path('..', __dir__),
               linters: ['rubocop'])
```
