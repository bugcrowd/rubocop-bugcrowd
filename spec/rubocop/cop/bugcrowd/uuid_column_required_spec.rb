# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Bugcrowd::UuidColumnRequired do
  subject(:cop) { described_class.new(config) }

  let(:config) { RuboCop::Config.new }

  it 'registers an offense' do
    expect_offense(<<~RUBY)
      def change
        create_table :blah do |t|
        ^^^^^^^^^^^^^^^^^^^^^ New tables should all have a uuid column of type uuid
          t.blah :blah
          t.uuid :uuid, null: false, default: 'gen_random_uuid()', index: { unique: false }
        end
      end
    RUBY
  end

  it 'registers an offense' do
    expect_offense(<<~RUBY)
      def change
        create_table :blah do |t|
        ^^^^^^^^^^^^^^^^^^^^^ New tables should all have a uuid column of type uuid
          t.uuid :uuid, null: false, default: 'gen_random_uuid()', index: { unique: false }
          t.blah :blah
        end
      end
    RUBY
  end

  it 'second line gives no offenses' do
    expect_no_offenses(<<~RUBY)
      def change
        create_table :blah do |t|
          t.blah :blah
          t.uuid :uuid, null: false, default: 'gen_random_uuid()', index: { unique: true }
        end
      end
    RUBY
  end

  it 'first line gives no offenses' do
    expect_no_offenses(<<~RUBY)
      def change
        create_table :blah do |t|
          t.uuid :uuid, null: false, default: 'gen_random_uuid()', index: { unique: true }
        end
      end
    RUBY
  end
end
