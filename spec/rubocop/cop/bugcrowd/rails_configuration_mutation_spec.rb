# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Bugcrowd::RailsConfigurationMutation do
  subject(:cop) { described_class.new(config) }

  let(:config) { RuboCop::Config.new }

  it 'registers an offense when using setter on Rails.configuration' do
    expect_offense(<<~RUBY)
      Rails.configuration.x.gambo = 'bingo'
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Avoid modifying rails configuration directly in specs, use stubbing instead
    RUBY
  end

  it 'registers an offense when using setter on Rails.application.config' do
    expect_offense(<<~RUBY)
      Rails.application.config.bizzle.active_record = 'bingo'
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Avoid modifying rails configuration directly in specs, use stubbing instead
    RUBY
  end

  it 'does not register an offense when using `#good_method`' do
    expect_no_offenses(<<~RUBY)
      Rails.configuration.x.gambo
    RUBY
  end

  it 'does not register an offense when using `#good_method`' do
    expect_no_offenses(<<~RUBY)
      Rails.application.config.x.gambo
    RUBY
  end
end
