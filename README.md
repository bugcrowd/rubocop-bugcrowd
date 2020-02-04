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

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

#### Generating a new cop

```bash
bundle exec rake 'new_cop[Bugcrowd/UseThisInsteadOfThat]'
```

The Rubocop documentation is decent (but getting better) for writing a new cop https://docs.rubocop.org/en/stable/development/#add-a-new-cop

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Rubocop::Bugcrowd project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/bugcrowd/rubocop-bugcrowd/blob/master/CODE_OF_CONDUCT.md).
