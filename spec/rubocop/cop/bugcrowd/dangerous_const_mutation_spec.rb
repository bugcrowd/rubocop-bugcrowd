# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Bugcrowd::DangerousConstMutation do
  subject(:cop) { described_class.new(config) }

  let(:config) { RuboCop::Config.new }

  it 'registers an offense when using setter on Current' do
    expect_offense(<<~RUBY)
      Current.thingo = 'bingo'
      ^^^^^^^^^^^^^^^^^^^^^^^^ Avoid using setter methods on Singleton consts directly
    RUBY
  end

  it 'does not register an offense when using `#good_method`' do
    expect_no_offenses(<<~RUBY)
      allow(Current).receive(:thingo).and_return 'bingo'
    RUBY
  end
end
