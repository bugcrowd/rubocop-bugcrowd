# frozen_string_literal: true

# TODO: when finished, run `rake generate_cops_documentation` to update the docs
module RuboCop
  module Cop
    module Bugcrowd
      # @example EnforcedStyle: bar (default)
      #   # Description of the `bar` style.
      #
      #   # bad
      #   bad_bar_method
      #
      #   # bad
      #   bad_bar_method(args)
      #
      #   # good
      #   good_bar_method
      #
      #   # good
      #   good_bar_method(args)
      #
      class DangerousConstMutation < Cop
        MSG = "Avoid using setter methods on Singleton consts directly"

        def setter?(method_name)
          method_name.to_s.end_with?('=')
        end

        def_node_matcher :bad_method?, <<~PATTERN
          (send (const nil? :Current) #setter? ...)
        PATTERN

        def on_send(node)
          return unless bad_method?(node)

          add_offense(node)
        end
      end
    end
  end
end
