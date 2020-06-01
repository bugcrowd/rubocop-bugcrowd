# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Bugcrowd::RequireOptionalForBelongsTo do
  subject(:cop) { described_class.new(config) }

  let(:config) { RuboCop::Config.new }

  context 'when optional is false' do
    it 'does not register an offence' do
      expect_no_offenses(<<~RUBY)
        class MyModel
          belongs_to :other_model, optional: false
        end
      RUBY
    end
  end

  context 'when optional is true' do
    it 'does not register an offence' do
      expect_no_offenses(<<~RUBY)
        class MyModel
          belongs_to :other_model, optional: true
        end
      RUBY
    end
  end

  context 'when belongs_to has many arguments' do
    it 'does not register an offence' do
      expect_no_offenses(<<~RUBY)
        class MyModel
          belongs_to :other_model, ->{ all }, class_name: 'Blah', optional: true, polymorphic: true
        end
      RUBY
    end
  end

  context 'when optional is not passed' do
    it 'registers an offense' do
      expect_offense(<<~RUBY)
        class MyModel
          belongs_to :other_model
          ^^^^^^^^^^^^^^^^^^^^^^^ Always specify whether belongs_to is optional using `optional: true/false`
        end
      RUBY
    end
  end

  context 'when optional is not passed with many arguments' do
    it 'registers an offence' do
      expect_offense(<<~RUBY)
        class MyModel
          belongs_to :other_model, ->{ all }, class_name: 'Blah', polymorphic: true
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Always specify whether belongs_to is optional using `optional: true/false`
        end
      RUBY
    end
  end

  context 'when optional is passed as nill' do
    it 'registers an offence' do
      expect_offense(<<~RUBY)
        class MyModel
          belongs_to :other_model, ->{ all }, class_name: 'Blah', polymorphic: true
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Always specify whether belongs_to is optional using `optional: true/false`
        end
      RUBY
    end
  end

  it 'autocorrect to add optional: true' do
    expect(
      autocorrect_source(
        "belongs_to :other_model, ->{ all }, class_name: 'Blah', polymorphic: true"
      )
    ).to eq(
      'belongs_to :other_model, ->{ all }, ' \
      "class_name: 'Blah', polymorphic: true, optional: true"
    )
  end
end
