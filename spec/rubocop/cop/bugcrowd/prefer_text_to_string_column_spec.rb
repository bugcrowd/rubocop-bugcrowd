# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Bugcrowd::PreferTextToStringColumn do
  subject(:cop) { described_class.new(config) }

  let(:config) { RuboCop::Config.new }

  it 'registers an offense when using `#bad_method`' do
    expect_offense(<<~RUBY)
      def change
        add_column :a, :b, :string
        ^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer text column to string, e.g. add_column :table, :column, :text. See https://www.depesz.com/2010/03/02/charx-vs-varcharx-vs-varchar-vs-text/
      end
    RUBY
  end

  it 'registers an offense when using `#bad_method`' do
    expect_offense(<<~RUBY)
      def change
        add_column :a, :b, :string, array: true
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer text column to string, e.g. add_column :table, :column, :text. See https://www.depesz.com/2010/03/02/charx-vs-varcharx-vs-varchar-vs-text/
      end
    RUBY
  end

  it 'registers an offense when using `#bad_method`' do
    expect_offense(<<~RUBY)
      def change
        add_column :a, :b, :some_random_thing, :string, array: true
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer text column to string, e.g. add_column :table, :column, :text. See https://www.depesz.com/2010/03/02/charx-vs-varcharx-vs-varchar-vs-text/
      end
    RUBY
  end

  it 'registers an offense when using `#bad_method`' do
    expect_no_offenses(<<~RUBY)
      def change
        add_column :a, :b, :text
      end
    RUBY
  end
end
