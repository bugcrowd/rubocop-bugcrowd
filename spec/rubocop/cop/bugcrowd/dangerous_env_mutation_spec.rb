# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Bugcrowd::DangerousEnvMutation do
  subject(:cop) { described_class.new(config) }

  let(:config) { RuboCop::Config.new }

  it 'registers an offense when modifying ENV directly' do
    expect_offense(<<~RUBY)
      ENV['anything'] = 'blah'
      ^^^^^^^^^^^^^^^^^^^^^^^^ Stub ENV or use configuration objects instead of directly modifying global ENV state
    RUBY
  end

  it 'does not register an offense when stubbing ENV' do
    expect_no_offenses(<<~RUBY)
      allow(ENV).to receive(:[])
    RUBY
  end
end
