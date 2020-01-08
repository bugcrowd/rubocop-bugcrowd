# frozen_string_literal: true

module RuboCop
  module Cop
    module Bugcrowd
      class TravelToBlockForm < RuboCop::Cop::Cop
        MSG = <<~COPCONTENT
          🚨  Prefer travel_to in its block form 🚨
        COPCONTENT

        def_node_matcher :parent_is_block?, <<-PATTERN
        (block (send nil? :travel_to ...) ...)
        PATTERN

        def on_send(node)
          add_offense(node) if node.command?(:travel_to) && !parent_is_block?(node.parent)
        end
      end
    end
  end
end
