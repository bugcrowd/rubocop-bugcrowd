# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Bugcrowd::NoIncludeRunInTransaction do
  subject(:cop) { described_class.new(config) }

  let(:config) { RuboCop::Config.new }

  it do
    expect_offense(<<~RUBY)
      class NewCommand
        include Interactor
        include RunInTransaction
        ^^^^^^^^^^^^^^^^^^^^^^^^ Bugcrowd/NoIncludeRunInTransaction: Prefer explicit transactions over wrapping entire command or organizer see: https://bugcrowd.atlassian.net/wiki/spaces/DEV/pages/589856783/How+to+use+activerecord+transactions
      end
    RUBY
  end

  it do
    expect_offense(<<~RUBY)
      class Commands::NewCommand
        include RunInTransaction
        ^^^^^^^^^^^^^^^^^^^^^^^^ Bugcrowd/NoIncludeRunInTransaction: Prefer explicit transactions over wrapping entire command or organizer see: https://bugcrowd.atlassian.net/wiki/spaces/DEV/pages/589856783/How+to+use+activerecord+transactions
        include Interactor
      end
    RUBY
  end

  it 'does not register an offense when using explicit transactions' do
    expect_no_offenses(<<~RUBY)
      class NewCommand
        include Interactor

        def call
          ActiveRecord::Base.transaction do
            new_record.save!
          end
        end
      end
    RUBY
  end
end
