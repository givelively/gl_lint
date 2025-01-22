# Give Lively Lint runner

`GLLint` is a Ruby gem that handles running linters against specific files (e.g. just the changed files from a branch). It leverages `git`, `rubocop` and `prettier`

This is particularly useful for large projects where you don't want to lint all the files in the project.

At Give Lively, we add an executable to `bin/lint` that calls this gem, to make it easy to autocorrect the files you change.

GLLint also adds a way to write a yaml file (`.rubocop_rules.yml`) with all the currently configured rubocop rules, via `bin/lint --write-rubocop-rules`. This is useful so that you can compare what changes from


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gl_lint', require: false
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install gl_lint

### bin/lint

Create a an executable `bin/lint` file with:

`touch bin/lint && chmod +x bin/lint`

Then add this to the file:

```ruby
#!/usr/bin/env ruby
require 'rubygems'
require 'gl_lint'

GLLint.call_cli(app_root: File.expand_path('..', __dir__))
```

Then run `bin/lint` to lint your changes.

Alternatively, if your project doesn't have JavaScript, add `linters: ['rubocop']`

```ruby
GLLint.call_cli(app_root: File.expand_path('..', __dir__),
                linters: ['rubocop'])
```
