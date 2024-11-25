# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Bugcrowd::DangerousTransaction do
  subject(:cop) { described_class.new(config) }

  let(:config) { RuboCop::Config.new }

  it 'registers an offense when using class level method' do
    expect_offense(<<~RUBY)
      Model.transaction { doing_a_thing }
      ^^^^^^^^^^^^^^^^^ Bugcrowd/DangerousTransaction: Use ProperTransaction.start instead of ActiveRecord's base, class, or instance-level transaction methods. See https://bugcrowd.atlassian.net/wiki/spaces/DEV/blog/2020/03/24/1126006819/Learnings+-+Nested+Transactions+in+Rails for more background
    RUBY
  end

  it 'registers an offense when using class level method' do
    expect_offense(<<~RUBY)
      Model.transaction { |d| d.doing_a_thing }
      ^^^^^^^^^^^^^^^^^ Bugcrowd/DangerousTransaction: Use ProperTransaction.start instead of ActiveRecord's base, class, or instance-level transaction methods. See https://bugcrowd.atlassian.net/wiki/spaces/DEV/blog/2020/03/24/1126006819/Learnings+-+Nested+Transactions+in+Rails for more background
    RUBY
  end

  it 'registers an offense when using class level method' do
    expect_offense(<<~RUBY)
      Model.transaction do |d|
      ^^^^^^^^^^^^^^^^^ Bugcrowd/DangerousTransaction: Use ProperTransaction.start instead of ActiveRecord's base, class, or instance-level transaction methods. See https://bugcrowd.atlassian.net/wiki/spaces/DEV/blog/2020/03/24/1126006819/Learnings+-+Nested+Transactions+in+Rails for more background
        d.doing_a_thing
      end
    RUBY
  end

  it 'registers an offense when using class level method' do
    expect_offense(<<~RUBY)
      Model.transaction(joinable: true, requires_new: true) do |d|
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Bugcrowd/DangerousTransaction: Use ProperTransaction.start instead of ActiveRecord's base, class, or instance-level transaction methods. See https://bugcrowd.atlassian.net/wiki/spaces/DEV/blog/2020/03/24/1126006819/Learnings+-+Nested+Transactions+in+Rails for more background
        d.doing_a_thing
      end
    RUBY
  end

  it 'registers an offense when using base class level method' do
    expect_offense(<<~RUBY)
      ActiveRecord::Base.transaction { doing_a_thing }
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Bugcrowd/DangerousTransaction: Use ProperTransaction.start instead of ActiveRecord's base, class, or instance-level transaction methods. See https://bugcrowd.atlassian.net/wiki/spaces/DEV/blog/2020/03/24/1126006819/Learnings+-+Nested+Transactions+in+Rails for more background
    RUBY
  end

  it 'registers an offense when using base class level method' do
    expect_offense(<<~RUBY)
      ActiveRecord::Base.transaction { doing_a_thing }
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Bugcrowd/DangerousTransaction: Use ProperTransaction.start instead of ActiveRecord's base, class, or instance-level transaction methods. See https://bugcrowd.atlassian.net/wiki/spaces/DEV/blog/2020/03/24/1126006819/Learnings+-+Nested+Transactions+in+Rails for more background
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
