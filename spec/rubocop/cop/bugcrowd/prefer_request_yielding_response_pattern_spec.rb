# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Bugcrowd::PreferRequestYieldingResponsePattern do
  subject(:cop) { described_class.new(config) }

  let(:config) { RuboCop::Config.new }

  it 'registers an offense visit in single line block' do
    expect_offense(<<~RUBY)
      before { post user_path }
      ^^^^^^^^^^^^^^^^^^^^^^^^^ Bugcrowd/PreferRequestYieldingResponsePattern: Prefer request_yielding_response pattern. See https://gist.github.com/maschwenk/6eaf0a3cbf0e6f1432b923cbca7e34d1

      it 'something happens' do
        expect(response).to have_http_status :ok
      end
    RUBY
  end

  it 'registers an offense when using multiline block' do
    expect_offense(<<~RUBY)
      before do
      ^^^^^^^^^ Bugcrowd/PreferRequestYieldingResponsePattern: Prefer request_yielding_response pattern. See https://gist.github.com/maschwenk/6eaf0a3cbf0e6f1432b923cbca7e34d1
        post user_path
        other_thing
      end
    RUBY
  end

  it 'registers an offense when using multiline block regardless of order' do
    expect_offense(<<~RUBY)
      before do
      ^^^^^^^^^ Bugcrowd/PreferRequestYieldingResponsePattern: Prefer request_yielding_response pattern. See https://gist.github.com/maschwenk/6eaf0a3cbf0e6f1432b923cbca7e34d1
        other_thing
        post user_path
      end
    RUBY
  end

  it 'registers an offense when using other request methods' do
    expect_offense(<<~RUBY)
      before do
      ^^^^^^^^^ Bugcrowd/PreferRequestYieldingResponsePattern: Prefer request_yielding_response pattern. See https://gist.github.com/maschwenk/6eaf0a3cbf0e6f1432b923cbca7e34d1
        other_thing
        patch user_path
      end
    RUBY
  end

  it 'does not register an offense when using request_yielding_response pattern' do
    expect_no_offenses(<<~RUBY)
      subject(:request_yielding_response) do
        http_request
        response
      end

      let(:http_request) { get user_path(name: 'dilbert') }

      it { is_expected.to be_ok }
      it 'blah' do
        expect { request_yielding_response }.to change(User, :count).by(1)
      end
    RUBY
  end
end
