# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Bugcrowd::CurrentJumpingControllerBoundary do
  subject(:cop) { described_class.new(config) }

  let(:config) { RuboCop::Config.new }

  it 'registers an offense when using Current' do
    expect_offense(<<~RUBY)
      Current.baz.bar
      ^^^^^^^^^^^ Current should not be used outside of controllers. Pass it along to other systems that need it
    RUBY
  end

  it 'does not register an offense for unrelated const' do
    expect_no_offenses(<<~RUBY)
      Flurrent.baz.bar
    RUBY
  end
end
