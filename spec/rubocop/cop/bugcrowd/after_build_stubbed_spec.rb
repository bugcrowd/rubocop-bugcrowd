# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Bugcrowd::AfterBuildStubbed do
  subject(:cop) { described_class.new(config) }

  let(:config) { RuboCop::Config.new }

  it 'registers an offense for :build_stubbed hook' do
    expect_offense(<<~RUBY)
      after(:build_stubbed) do |model_instance|
      ^^^^^^^^^^^^^^^^^^^^^ :build_stubbed is not a FactoryBot after hook, instead use :stub, :build, or :create
        model_instance.attribute = 'thingo'
      end
    RUBY
  end

  it 'does not flag :stub hook' do
    expect_no_offenses(<<~RUBY)
      after(:stub) do |model_instance|
        model_instance.attribute = 'thingo'
      end
    RUBY
  end
end
