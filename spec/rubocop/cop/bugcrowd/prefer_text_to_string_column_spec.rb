# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Bugcrowd::PreferTextToStringColumn do
  subject(:cop) { described_class.new(config) }

  let(:config) { RuboCop::Config.new }

  it 'registers an offense for first argument' do
    expect_offense(<<~RUBY)
      def change
        add_column :a, :b, :string
        ^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer text column to string, e.g. add_column :table, :column, :text. See https://www.depesz.com/2010/03/02/charx-vs-varcharx-vs-varchar-vs-text/
      end
    RUBY
  end

  it 'registers an offense for arbitrary n variables after the string' do
    expect_offense(<<~RUBY)
      def change
        add_column :a, :b, :string, array: true
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer text column to string, e.g. add_column :table, :column, :text. See https://www.depesz.com/2010/03/02/charx-vs-varcharx-vs-varchar-vs-text/
      end
    RUBY
  end

  it 'registers an offense for arbitrary n variables before the string' do
    expect_offense(<<~RUBY)
      def change
        add_column :a, :b, :blah, :string, array: true
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer text column to string, e.g. add_column :table, :column, :text. See https://www.depesz.com/2010/03/02/charx-vs-varcharx-vs-varchar-vs-text/
      end
    RUBY
  end

  it 'registers an offense within create_table calls' do
    expect_offense(<<~RUBY)
      def change
        create_table :a_table, blah: :dah do |z|
          z.string :col
          ^^^^^^^^^^^^^ Prefer text column to string, e.g. add_column :table, :column, :text. See https://www.depesz.com/2010/03/02/charx-vs-varcharx-vs-varchar-vs-text/
        end
      end
    RUBY
  end

  it 'registers an offense within create_table calls' do
    expect_offense(<<~RUBY)
      def change
        create_table :a_table, blah: :dah do |z|
          z.goober :name
          z.string :col
          ^^^^^^^^^^^^^ Prefer text column to string, e.g. add_column :table, :column, :text. See https://www.depesz.com/2010/03/02/charx-vs-varcharx-vs-varchar-vs-text/
        end
      end
    RUBY
  end

  it 'does not flag text columns' do
    expect_no_offenses(<<~RUBY)
      def change
        add_column :a, :b, :text
      end
    RUBY
  end
end
