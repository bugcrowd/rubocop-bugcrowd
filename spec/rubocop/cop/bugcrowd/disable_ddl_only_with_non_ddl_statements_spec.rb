# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Bugcrowd::DisableDdlOnlyWithNonDdlStatements do
  subject(:cop) { described_class.new(config) }

  let(:config) { RuboCop::Config.new }

  # create_table(:table_name, :column_name)
  # add_column(:table_name, :column_name)
  # add_foreign_key(:table_name, :column_name)
  # add_index(:table_name, :column_name)
  # add_reference(:table_name, :column_name)
  # add_timestamps(:table_name, :column_name)
  # change_column(:table_name, :column_name)
  # change_column_default(:table_name, :column_name)
  # change_column_null(:table_name, :column_name)
  # change_table(:table_name, :column_name)
  # rename_column(:table_name, :column_name)
  # rename_index(:table_name, :column_name)
  # rename_table(:table_name, :column_name)
  # drop_table(:table_name, :column_name)
  # drop_join_table(:table_name, :column_name)
  # remove_column(:table_name, :column_name)
  # remove_columns(:table_name, :column_name)
  # remove_foreign_key(:table_name, :column_name)
  # remove_index(:table_name, :column_name)
  # remove_index(:table_name, :column_name)
  # remove_reference(:table_name, :column_name)
  # remove_timestamps(:table_name, :column_name)
  # For example
  it 'registers an offense when adding a column with disable_ddl_transaction!' do
    expect_offense(<<~RUBY)
      class DerpMigration < ActiveRecord::Migration[5.2]
        disable_ddl_transaction!

        def change
          add_column(:table_name, :offensive_name)
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Only disable ddl transactions for non-ddl statements
        end
      end
    RUBY
  end

  it 'registers an offense when adding a column with disable_ddl_transaction!' do
    expect_offense(<<~RUBY)
      class DerpMigration < ActiveRecord::Migration[5.2]
        disable_ddl_transaction!

        def up
          add_column(:table_name, :offensive_name)
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Only disable ddl transactions for non-ddl statements
        end
      end
    RUBY
  end

  it 'registers an offense deeply within ancestors' do
    expect_offense(<<~RUBY)
      class DerpMigration < ActiveRecord::Migration[5.2]
        disable_ddl_transaction!

        def up
          4.times do |x|
            add_column(:table_name, :offensive_name)
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Only disable ddl transactions for non-ddl statements
          end
        end
      end
    RUBY
  end

  it 'does not register an offense when using the directive with a non-ddl command' do
    expect_no_offenses(<<~RUBY)
      class DerpMigration < ActiveRecord::Migration[5.2]
        disable_ddl_transaction!

        def change
          add_index :table_name, :column_name, unique: true, algorithm: :concurrently
        end
      end
    RUBY
  end

  it 'does not register an offense when not using the directive' do
    expect_no_offenses(<<~RUBY)
      class DerpMigration < ActiveRecord::Migration[5.2]
        def change
          add_column(:table_name, :column_name)
        end
      end
    RUBY
  end
end
