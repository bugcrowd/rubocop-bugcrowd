# frozen_string_literal: true

module RuboCop
  module Cop
    module Bugcrowd
      class PreferRequestYieldingResponsePattern < Base
        #
        # @example
        #
        # # bad
        # ```
        # before { post user_path }
        # it 'something happens' do
        #   expect(response).to have_http_status :ok
        # end
        # ```
        #
        # # bad
        # This pattern is not easily parseable, but is no better than
        # the above pattern because it just gives the before a different name
        # ```
        # before { request }
        # let(:request) { get user_path }
        # it 'something happens' do
        #   expect(response).to have_http_status :ok
        # end
        # ```
        #
        # # good
        # Seperate the subject of the test from the test setup
        # Use late binding to allow for more predictable behavior
        # ```
        #  subject(:request_yielding_response) do
        #    http_request
        #    response
        #  end
        #  let(:http_request) { get user_path(name: 'dilbert') }
        #  it { is_expected.to be_ok }
        #  it 'blah' do
        #    expect { request_yielding_response }.to change(User, :count).by(1)
        #  end
        # ```
        #
        # # good
        # Directly calling the request method is fine too!
        # ```
        #  it 'blah' do
        #    get user_path(name: 'dilbert')
        #  end
        # ```
        #

        MSG = 'Prefer request_yielding_response pattern. See https://gist.github.com/maschwenk/6eaf0a3cbf0e6f1432b923cbca7e34d1'

        def_node_matcher :begin_before_block?, <<~PATTERN
          (block (send nil? :before) ...)
        PATTERN

        # using a search here to search the children of the before
        def_node_search :calling_crud_method?, <<~PATTERN
          (send nil? #crud_method? ...)
        PATTERN

        def crud_method?(meth)
          %i[get put post patch delete].include? meth
        end

        def on_block(node)
          if begin_before_block?(node) && calling_crud_method?(node)
            add_offense(node)
          end
        end
      end
    end
  end
end
