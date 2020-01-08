# Rubocop::Bugcrowd

Rubocop custom extension for rules specific to Bugcrowd's projects. Custom extension lets us share between projects and more easily test the cops in isolation. Many of these cops are not universally applicable to Rails/Ruby projects, they are simply a way of deprecating/prefering certain patterns as teams and projects grow.

To experiment, run `bin/console` for an interactive prompt.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rubocop-bugcrowd', require: false
```

and require it at the top of your `.rubocop.yml`

```yaml
require:
  - rubocop-bugcrowd
```
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Rubocop::Bugcrowd project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/bugcrowd/rubocop-bugcrowd/blob/master/CODE_OF_CONDUCT.md).
