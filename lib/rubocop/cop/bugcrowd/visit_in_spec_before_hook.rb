# frozen_string_literal: true

# TODO: when finished, run `rake generate_cops_documentation` to update the docs
module RuboCop
  module Cop
    module Bugcrowd
      class VisitInSpecBeforeHook < Base
        MSG = "Avoid calling 'visit' in before hooks. See https://gist.github.com/maschwenk/6eaf0a3cbf0e6f1432b923cbca7e34d1"

        def_node_matcher :begin_before_block?, <<~PATTERN
          (block (send nil? :before) ...)
        PATTERN

        # using a search here to search the children of the visit
        def_node_search :visit?, <<~PATTERN
          (send nil? :visit ...)
        PATTERN

        def on_block(node)
          if begin_before_block?(node) && visit?(node)
            add_offense(node)
          end
        end
      end
    end
  end
end
