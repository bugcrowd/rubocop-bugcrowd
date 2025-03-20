# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Bugcrowd::PreventBugsnagUsage, :config do
  subject(:cop) { described_class.new(config) }

  it 'registers an offense when Bugsnag is used as a constant' do
    expect_offense(<<~RUBY)
      Bugsnag.error('Error')
      ^^^^^^^^^^^^^^^^^^^^^^ Avoid using Bugsnag in the codebase. It has been replaced with ErrorNotifierService for error notification handling. Please use ErrorNotifierService instead.
    RUBY
  end

  it 'registers an offense when Bugsnag.notify is used' do
    expect_offense(<<~RUBY)
      Bugsnag.notify('Error')
      ^^^^^^^^^^^^^^^^^^^^^^^ Avoid using Bugsnag in the codebase. It has been replaced with ErrorNotifierService for error notification handling. Please use ErrorNotifierService instead.
    RUBY
  end

  it 'does not register an offense when ErrorNotifierService is used' do
    expect_no_offenses(<<~RUBY)
      ErrorNotifierService.notify('Error')
    RUBY
  end
end
