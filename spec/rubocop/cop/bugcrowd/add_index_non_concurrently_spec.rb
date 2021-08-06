# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Bugcrowd::AddIndexNonConcurrently do
  subject(:cop) { described_class.new(config) }

  let(:config) { RuboCop::Config.new }

  it do
    expect_offense(<<~RUBY)
      def change
        add_index :table_name, [:derp, :dap], unique: true, algorithm: :flunflurrently
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ By default, Postgres locks writes to a table while creating an index on it  -- always add indexes concurrently, e.g. add_index :table_name, :column, algorithm: :concurrently
      end
    RUBY
  end

  it do
    expect_offense(<<~RUBY)
      def change
        add_index :table_name, [:derp, :dap], unique: true
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ By default, Postgres locks writes to a table while creating an index on it  -- always add indexes concurrently, e.g. add_index :table_name, :column, algorithm: :concurrently
      end
    RUBY
  end

  it do
    expect_offense(<<~RUBY)
      def up
        add_index :table_name, :column_name, unique: true
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ By default, Postgres locks writes to a table while creating an index on it  -- always add indexes concurrently, e.g. add_index :table_name, :column, algorithm: :concurrently
      end
    RUBY
  end

  it 'registers an offense when multiple add_index calls' do
    expect_offense(<<~RUBY)
      def change
        add_index :table_name, :column_name, unique: true
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ By default, Postgres locks writes to a table while creating an index on it  -- always add indexes concurrently, e.g. add_index :table_name, :column, algorithm: :concurrently
        add_index :table_name, :column_name, unique: true
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ By default, Postgres locks writes to a table while creating an index on it  -- always add indexes concurrently, e.g. add_index :table_name, :column, algorithm: :concurrently
      end
    RUBY
  end

  it do
    expect_offense(<<~RUBY)
      def up
        remove_index :table_name, :column_name, unique: true
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ By default, Postgres locks writes to a table while creating an index on it  -- always add indexes concurrently, e.g. add_index :table_name, :column, algorithm: :concurrently
      end
    RUBY
  end

  it 'does not register an offense when using concurrently' do
    expect_no_offenses(<<~RUBY)
      def change
        remove_index :table_name, :column, algorithm: :concurrently
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

  it 'does not register an offense when using concurrently with other arg types' do
    expect_no_offenses(<<~RUBY)
      def change
        add_index :table_name, [:derp, :dap], unique: true, algorithm: :concurrently
      end
    RUBY
  end

  it 'does not register an offense when using concurrently with other arg types within up' do
    expect_no_offenses(<<~RUBY)
      def up
        add_index :table_name, [:derp, :dap], unique: true, algorithm: :concurrently
      end
    RUBY
  end

  it 'does not register an offense when using concurrently in random orders' do
    expect_no_offenses(<<~RUBY)
      def up
        add_index :table_name, [:derp, :dap], algorithm: :concurrently, unique: true
      end
    RUBY
  end
end
