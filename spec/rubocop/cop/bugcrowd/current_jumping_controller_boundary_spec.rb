# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Bugcrowd::CurrentJumpingControllerBoundary do
  subject(:cop) { described_class.new(config) }

  let(:config) { RuboCop::Config.new }

  it 'registers an offense when using Current' do
    expect_offense(<<~RUBY)
      Current.baz.bar
      ^^^^^^^^^^^ Curent should not be used outside of controllers. Pass it along to other systems that need it
    RUBY
  end
end
