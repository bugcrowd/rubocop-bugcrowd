# frozen_string_literal: true

module RuboCop
  module Cop
    module Bugcrowd
      class AfterBuildStubbed < RuboCop::Cop::Cop
        MSG = ':build_stubbed is not a FactoryBot after hook, instead use :stub, :build, or :create'

        def_node_matcher :after_build_stubbed?, <<-PATTERN
        (send nil? :after <(sym :build_stubbed) ...>)
        PATTERN

        def on_send(node)
          add_offense(node) if after_build_stubbed?(node)
        end

        # def autocorrect(node)
        #   lambda do |corrector|
        #     internal_expression = node.children.last
        #     corrector.replace(
        #       internal_expression.loc.expression, "#{internal_expression.source}.new"
        #     )
        #   end
        # end
      end
    end
  end
end
