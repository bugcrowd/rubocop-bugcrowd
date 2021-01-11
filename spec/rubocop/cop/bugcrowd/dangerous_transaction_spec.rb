# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Bugcrowd::DangerousTransaction do
  subject(:cop) { described_class.new(config) }

  let(:config) { RuboCop::Config.new }

  it 'registers an offense when using class level method' do
    expect_offense(<<~RUBY)
      Model.transaction { doing_a_thing }
      ^^^^^^^^^^^^^^^^^ Use ProperTransaction.start instead of ActiveRecord's base, class, or instance-level transaction methods.
    RUBY
  end

  it 'registers an offense when using class level method' do
    expect_offense(<<~RUBY)
      Model.transaction { |d| d.doing_a_thing }
      ^^^^^^^^^^^^^^^^^ Use ProperTransaction.start instead of ActiveRecord's base, class, or instance-level transaction methods.
    RUBY
  end

  it 'registers an offense when using class level method' do
    expect_offense(<<~RUBY)
      Model.transaction do |d|
      ^^^^^^^^^^^^^^^^^ Use ProperTransaction.start instead of ActiveRecord's base, class, or instance-level transaction methods.
        d.doing_a_thing
      end
    RUBY
  end

  it 'registers an offense when using class level method' do
    expect_offense(<<~RUBY)
      Model.transaction(joinable: true, requires_new: true) do |d|
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use ProperTransaction.start instead of ActiveRecord's base, class, or instance-level transaction methods.
        d.doing_a_thing
      end
    RUBY
  end

  it 'registers an offense when using base class level method' do
    expect_offense(<<~RUBY)
      ActiveRecord::Base.transaction { doing_a_thing }
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use ProperTransaction.start instead of ActiveRecord's base, class, or instance-level transaction methods.
    RUBY
  end

  it 'registers an offense when using base class level method' do
    expect_offense(<<~RUBY)
      ActiveRecord::Base.transaction { doing_a_thing }
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use ProperTransaction.start instead of ActiveRecord's base, class, or instance-level transaction methods.
    RUBY
  end

  it 'does not register an offense when using ProperTransaction' do
    expect_no_offenses(<<~RUBY)
      ProperTransaction.start do |d|
        d.doing_a_thing
      end
    RUBY
  end

  it 'does not register an offense when using ProperTransaction' do
    expect_no_offenses(<<~RUBY)
      ProperTransaction.start { doing_a_thing }
    RUBY
  end
end
