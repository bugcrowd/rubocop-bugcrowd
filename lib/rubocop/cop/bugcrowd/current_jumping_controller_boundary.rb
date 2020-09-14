# frozen_string_literal: true

# TODO: when finished, run `rake generate_cops_documentation` to update the docs
module RuboCop
  module Cop
    module Bugcrowd
      # @example EnforcedStyle: bar (default)
      #   # Description of the `bar` style.
      #
      #   # bad
      #   Current.thingo
      #
      #   # good
      #   Command.call(thing: Current.thingo)
      #
      class CurrentJumpingControllerBoundary < Cop
        MSG = 'Current should not be used outside of controllers. '\
              'Pass it along to other systems that need it'

        def_node_matcher :current_called?, <<~PATTERN
          (send (const nil? :Current) _ ...)
        PATTERN

        def on_send(node)
          return unless current_called?(node)

          add_offense(node)
        end
      end
    end
  end
end
