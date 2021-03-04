# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Bugcrowd::PreferSensibleStringEnum do
  subject(:cop) { described_class.new(config) }

  let(:config) { RuboCop::Config.new }

  it 'registers an offense when using `#enum`' do
    expect_offense(<<~RUBY)
      enum species: { dog: 'dog' }
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer SensibleStringEnum over built in Rails enum.
    RUBY
  end

  it 'registers an offense when using `#enum` in multiline' do
    expect_offense(<<~RUBY)
      enum species: {
      ^^^^^^^^^^^^^^^ Prefer SensibleStringEnum over built in Rails enum.
        dog: 'dog'
      }
    RUBY
  end

  it 'does not register an offense when using `#enumerate_strings_for`' do
    expect_no_offenses(<<~RUBY)
      enumerate_strings_for :species, %i[dog cat bird], allow_nil: true
    RUBY
  end
end
