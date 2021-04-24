# frozen_string_literal: true

module RuboCop
  module Cop
    module Bugcrowd
      class PreferRequestYieldingResponsePattern < Cop
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
