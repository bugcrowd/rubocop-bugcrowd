# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Bugcrowd::PreventBugsnagUsage, :config do
  subject(:cop) { described_class.new(config) }

  let(:message) do
    'Do not use Bugsnag in the codebase, as its integration has been removed. ' \
    'Use ErrorTrackingService for reporting errors.'
  end

  it 'registers an offense when Bugsnag is used' do
    expect_offense(<<~RUBY)
      Bugsnag.error('Error')
      ^^^^^^^^^^^^^^^^^^^^^^ #{message}
    RUBY
  end

  it 'registers an offense when Bugsnag.notify is used' do
    expect_offense(<<~RUBY)
      Bugsnag.notify('Error')
      ^^^^^^^^^^^^^^^^^^^^^^^ #{message}
    RUBY
  end

  it 'does not register an offense for ErrorTrackingService' do
    expect_no_offenses(<<~RUBY)
      ErrorTrackingService.notify('Error')
    RUBY
  end

  it 'does not register an offense for unrelated constants' do
    expect_no_offenses(<<~RUBY)
      SomeOtherService.notify('Error')
    RUBY
  end

  it 'does not register an offense for lowercase bugsnag' do
    expect_no_offenses(<<~RUBY)
      bugsnag.error('Error')
    RUBY
  end

  it 'does not register an offense for local variable named Bugsnag' do
    expect_no_offenses(<<~RUBY)
      bugsnag = SomeService.new
      bugsnag.error('Error')
    RUBY
  end
end
