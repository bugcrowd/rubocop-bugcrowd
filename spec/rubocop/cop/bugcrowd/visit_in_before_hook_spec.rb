# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Bugcrowd::VisitInBeforeHook do
  subject(:cop) { described_class.new(config) }

  let(:config) { RuboCop::Config.new }

  # TODO: Write test code
  #
  # For example
  it 'registers an offense when using `#bad_method`' do
    expect_offense(<<~RUBY)
      before { visit(blah) }
      ^^^^^^^^^^^^^^^^^^^^^^ Don\'t call visit within before hooks
    RUBY
  end

  it 'registers an offense when using `#bad_method`' do
    expect_offense(<<~RUBY)
      before do
      ^^^^^^^^^ Don\'t call visit within before hooks
        visit(blah)
        other_thing
      end
    RUBY
  end

  it 'registers an offense when using `#bad_method`' do
    expect_offense(<<~RUBY)
      before do
      ^^^^^^^^^ Don\'t call visit within before hooks
        other_thing
        visit(blah)
      end
    RUBY
  end

  it 'does not register an offense when using `#good_method`' do
    expect_no_offenses(<<~RUBY)
      good_method
    RUBY
  end
end
