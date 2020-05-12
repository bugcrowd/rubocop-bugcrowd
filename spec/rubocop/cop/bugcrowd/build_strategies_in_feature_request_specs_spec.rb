# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Bugcrowd::BuildStrategiesInFeatureRequestSpecs do
  subject(:cop) { described_class.new(config) }

  let(:config) { RuboCop::Config.new }

  # TODO: Write test code
  #
  # For example
  it 'registers an offense when using `#bad_method`' do
    expect_offense(<<~RUBY)
      build(:model_name, :thing, other: 'yay')
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer 'create' in request/feature specs
    RUBY
  end

  it 'registers an offense when using `#bad_method`' do
    expect_offense(<<~RUBY)
      build_stubbed(:model_name, :thing, other: 'yay')
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer 'create' in request/feature specs
    RUBY
  end

  it 'does not register an offense when using `#good_method`' do
    expect_no_offenses(<<~RUBY)
      create(:blah, :zah)
    RUBY
  end
end
