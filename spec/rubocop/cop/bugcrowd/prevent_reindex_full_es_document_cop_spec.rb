# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Bugcrowd::PreventReindexFullESDocumentCop do
  subject(:cop) { described_class.new(config) }

  let(:config) { RuboCop::Config.new }

  it 'registers an offence when reindexing a full elasticsearch document' do
    expect_offense(<<~RUBY)
      ValisCommands::ReindexDocument.call(document_type: 'SubmissionDocument')
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Bugcrowd/PreventReindexFullESDocumentCop: Avoid reindexing the full Elasticsearch document. Consider reindexing only specific resource ids.
    RUBY
  end

  it 'does not register an offense when reindexing only a specific resource ID' do
    expect_no_offenses(<<~RUBY)
      ValisReindexWorker.new.perform([submission.id], Submission.to_s)
    RUBY
  end
end
