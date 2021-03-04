# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Bugcrowd::SidekiqTestingInline do
  subject(:cop) { described_class.new(config) }

  let(:config) { RuboCop::Config.new }

  it 'registers an offence when calling Sidekiq::Testing::Inline!' do
    expect_offense(<<~RUBY)
      Sidekiq::Testing.inline!
      ^^^^^^^^^^^^^^^^^^^^^^^^ Prefer to drain the worker, then calling `Sidekiq::Testing.inline!`
    RUBY
  end

  it 'does not register an offense when calling another method' do
    expect_no_offenses(<<~RUBY)
      Sidekiq::Testing.offline
    RUBY
  end
end
