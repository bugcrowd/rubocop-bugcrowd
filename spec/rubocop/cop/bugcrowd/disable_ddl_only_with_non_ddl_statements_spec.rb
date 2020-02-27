# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Bugcrowd::DisableDdlOnlyWithNonDdlStatements do
  subject(:cop) { described_class.new(config) }

  let(:config) { RuboCop::Config.new }

  # TODO: Write test code
  #

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
  it 'registers an offense when using `#bad_method`' do
    expect_offense(<<~RUBY)
      add_index :table_name, [:derp, :dap], unique: true, algorithm: :flunflurrently
    RUBY
  end

  xit 'does not register an offense when using `#good_method`' do
    expect_no_offenses(<<~RUBY)
      good_method
    RUBY
  end
end
