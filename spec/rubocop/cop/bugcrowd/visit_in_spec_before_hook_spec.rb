# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Bugcrowd::VisitInSpecBeforeHook do
  subject(:cop) { described_class.new(config) }

  let(:config) { RuboCop::Config.new }

  it 'registers an offense visit in single line block' do
    expect_offense(<<~RUBY)
      before { visit(blah) }
      ^^^^^^^^^^^^^^^^^^^^^^ Avoid calling 'visit' in before hooks. See https://gist.github.com/maschwenk/6eaf0a3cbf0e6f1432b923cbca7e34d1
    RUBY
  end

  it 'registers an offense when using multiline block' do
    expect_offense(<<~RUBY)
      before do
      ^^^^^^^^^ Avoid calling 'visit' in before hooks. See https://gist.github.com/maschwenk/6eaf0a3cbf0e6f1432b923cbca7e34d1
        visit(blah)
        other_thing
      end
    RUBY
  end

  it 'registers an offense when using multiline block regardless of order' do
    expect_offense(<<~RUBY)
      before do
      ^^^^^^^^^ Avoid calling 'visit' in before hooks. See https://gist.github.com/maschwenk/6eaf0a3cbf0e6f1432b923cbca7e34d1
        other_thing
        visit(blah)
      end
    RUBY
  end

  it 'does not register an offense when using within an it block' do
    expect_no_offenses(<<~RUBY)
      it 'blah blah' do
        visit page
        expect(page).to have_text 'blah'
      end
    RUBY
  end

  it 'does not register an offense when using subject approach' do
    expect_no_offenses(<<~RUBY)
      subject(:visited_page) do
        visit page_under_test
        page
      end

      before { setup_my_mocks }

      let!(:_other_mocks) { }

      context 'one page' do
        let(:page_under_test) { posts_path }

        it { is_expected.to have_text 'hellow world' }
      end

      context 'another page' do
        let(:page_under_test) { users_path }

        it { is_expected.to have_text 'hellow world' }
      end
    RUBY
  end
end
