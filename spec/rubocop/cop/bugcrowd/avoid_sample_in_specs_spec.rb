# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Bugcrowd::AvoidSampleInSpecs do
  subject(:cop) { described_class.new(config) }

  let(:config) { RuboCop::Config.new }

  it 'registers an offense when using sample' do
    expect_offense(<<~RUBY)
      blah.zah.sample
      ^^^^^^^^^^^^^^^ Avoid using sample in spec as it can cause non-deterministic behavior
    RUBY
  end

  it 'registers an offense when using sample with single arg' do
    expect_offense(<<~RUBY)
      blah.zah.sample(3)
      ^^^^^^^^^^^^^^^^^^ Avoid using sample in spec as it can cause non-deterministic behavior
    RUBY
  end

  it 'registers an offense when using sample with random' do
    expect_offense(<<~RUBY)
      blah.zah.sample(3, random: 1)
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Avoid using sample in spec as it can cause non-deterministic behavior
    RUBY
  end

  it 'does not register an offense when using a different method' do
    expect_no_offenses(<<~RUBY)
      blah.zah.not_sample
    RUBY
  end
end
