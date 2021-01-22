# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Bugcrowd::NoEventDeprecatedPublish do
  subject(:cop) { described_class.new(config) }

  let(:config) { RuboCop::Config.new }

  it 'registers an offence when calling deprecated_publish on EventStore' do
    expect_offense(<<~RUBY)
      EventStore.deprecated_publish(data: { blah: 'string' })
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer the new form of saving the event first within the same transaction as the data mutation, then calling `new_event.publish!` outside of the transaction.
    RUBY
  end

  it 'does not register an offense when using the new form of publish' do
    expect_no_offenses(<<~RUBY)
      event = Event.create!(data: { blah: 'string' })
      event.publish!
    RUBY
  end
end
