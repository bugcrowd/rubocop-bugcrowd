# frozen_string_literal: true

module RuboCop
  module Cop
    module Bugcrowd
      class CanWithClassConst < RuboCop::Cop::Cop
        MSG = <<~COPCONTENT
          🚨 Don't call can? with a class constant, as it will unexpectedly pass. Use an instance instead. (https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities-with-Blocks#only-for-object-attributes) 🚨
        COPCONTENT

        def_node_matcher :can_with_class_const?, <<-PATTERN
        (send _ :can? _ (const nil? _))
        PATTERN

        def on_send(node)
          add_offense(node) if can_with_class_const?(node)
        end

        def autocorrect(node)
          lambda do |corrector|
            internal_expression = node.children.last
            corrector.replace(
              internal_expression.loc.expression, "#{internal_expression.source}.new"
            )
          end
        end
    end
    end
end
end
