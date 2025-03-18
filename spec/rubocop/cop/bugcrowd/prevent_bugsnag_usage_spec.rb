# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Bugcrowd::PreventBugsnagUsage do
  subject(:cop) { described_class.new(config) }
  let(:config) { RuboCop::Config.new }

  it 'registers an offense when Bugsnag.notify is used' do
    expect_offense(<<~RUBY)
      Bugsnag.notify('Error')
      ^^^^^^^ Bugcrowd/PreventBugsnagUsage: Avoid using Bugsnag in the codebase. It has been replaced with ErrorNotifierService for error notification handling. Please use ErrorNotifierServiceinstead.
      ^^^^^^^^^^^^^^^^^^^^^^^ Bugcrowd/PreventBugsnagUsage: Avoid using Bugsnag in the codebase. It has been replaced with ErrorNotifierService for error notification handling. Please use ErrorNotifierServiceinstead.
    RUBY
  end

  it 'registers an offense when Bugsnag is used as a constant' do
    expect_offense(<<~RUBY)
      Bugsnag.error('Error')
      ^^^^^^^ Bugcrowd/PreventBugsnagUsage: Avoid using Bugsnag in the codebase. It has been replaced with ErrorNotifierService for error notification handling. Please use ErrorNotifierServiceinstead.
    RUBY
  end

  it 'does not register an offense when ErrorNotifierService is used' do
    expect_no_offenses(<<~RUBY)
      ErrorNotifierService.notify('Error')
    RUBY
  end

  it 'does not register an offense when no Bugsnag is used' do
    expect_no_offenses(<<~RUBY)
      SomeOtherService.notify('Error')
    RUBY
  end
end
