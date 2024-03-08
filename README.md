# Give Lively Lint

Linting tool.

Create a file in `bin/lint` and add this:

```ruby
#!/usr/bin/env ruby
require 'gl_lint'

GlLint.run_cli(app_root: File.expand_path('..', __dir__))
```

Then run `bin/lint` to lint your code.