# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Bugcrowd::SleepySpecs do
  subject(:cop) { described_class.new(config) }

  let(:config) { RuboCop::Config.new }

  # TODO: Write test code
  #
  # For example
  xit 'registers an offense when using `#bad_method`' do
    expect_offense(<<~RUBY)
      sleep(1)
      ^^^^^^^^ Bugcrowd/SleepySpecs: 🚨  Do not use sleep, use wait instead 🚨
    RUBY
  end

  xit 'does not register an offense when using `#good_method`' do
    expect_no_offenses(<<~RUBY)
      literally_anything_else
    RUBY
  end
end
