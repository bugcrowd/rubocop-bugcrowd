# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Bugcrowd::NoUnrestrictedPolymorph do
  subject(:cop) { described_class.new(config) }

  let(:config) { RuboCop::Config.new }

  context 'when belongs_to has no other rarguments' do
    it 'does not register an offence' do
      expect_no_offenses(<<~RUBY)
        class MyModel
          belongs_to :other_model
        end
      RUBY
    end
  end

  context 'when belongs_to has many arguments' do
    it 'does not register an offence' do
      expect_no_offenses(<<~RUBY)
        class MyModel
          belongs_to :other_model, ->{ all }, class_name: 'Blah', optional: true
        end
      RUBY
    end
  end

  context 'when polymorphic is true' do
    it 'registers an offence' do
      expect_offense(<<~RUBY)
        class MyModel
          belongs_to :other_model, polymorphic: true
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Always use `SafePolymorphic#polymorphic_belongs_to` to define polymorphic relationships
        end
      RUBY
    end
  end

  context 'when polymorphic is among many arguments' do
    it 'registers an offence' do
      expect_offense(<<~RUBY)
        class MyModel
          belongs_to :other_model, ->{ all }, class_name: 'Blah', polymorphic: true, optional: false
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Always use `SafePolymorphic#polymorphic_belongs_to` to define polymorphic relationships
        end
      RUBY
    end
  end
end
