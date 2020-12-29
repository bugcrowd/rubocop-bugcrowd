# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Bugcrowd::NoIncludeRunInTransaction do
  subject(:cop) { described_class.new(config) }

  let(:config) { RuboCop::Config.new }

  it do
    expect_offense(<<~RUBY)
      def NewCommand
        include Interactor
        include RunInTransaction
        ^^^^^^^^^^^^^^^^^^^^^^^^ my new message
      end
    RUBY
  end

  it 'does not register an offense when using concurrently' do
    expect_no_offenses(<<~RUBY)
      def change
        add_index :table_name, :column, algorithm: :concurrently
      end
    RUBY
  end
end
