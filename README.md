# EarlyHintsHeader

![Ruby](https://github.com/ianks/early_hints_header/workflows/Ruby/badge.svg)

An early hints Ruby / Rack middleware which just sets Link headers.

This means you can use early hints _without_ having to use the HTTP 103
status code, i.e. [nginx's
http2_push_preload](https://www.nginx.com/blog/nginx-1-13-9-http2-server-push/#automatic-push).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'early_hints_header'
gem 'fast_woothee' # optional: for blocking broken client like iOS
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install early_hints_header

## Usage

```ruby
# In config.ru

require "early_hints_header/middleware"

use EarlyHintsHeader::Middleware
```

## Caveats

When using HTTP2 push, be aware of potential clients that do not properly
support preloading. For example, [certain older Safari
versions](https://jakearchibald.com/2017/h2-push-tougher-than-i-thought/) do
not work properly. This gem will handle that if you have
[fast_woothee](https://github.com/ianks/fast_woothee) installed.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then,
run `rake spec` to run the tests. You can also run `bin/console` for an
interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.
To release a new version, update the version number in `version.rb`, and then
run `bundle exec rake release`, which will create a git tag for the version,
push git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/ianks/early_hints_header. This project is intended to
be a safe, welcoming space for collaboration, and contributors are expected
to adhere to the [code of
conduct](https://github.com/ianks/early_hints_header/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT
License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the EarlyHintsHeader project's codebases, issue
trackers, chat rooms and mailing lists is expected to follow the [code of
conduct](https://github.com/ianks/early_hints_header/blob/master/CODE_OF_CONDUCT.md).
