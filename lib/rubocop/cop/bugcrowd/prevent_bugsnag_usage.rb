# frozen_string_literal: true

module RuboCop
  module Cop
    module Bugcrowd
      class PreventBugsnagUsage < Cop
        MSG = 'Avoid using Bugsnag in the codebase. ' \
              'It has been replaced with ErrorNotifierService for error ' \
              'notification handling. Please use ErrorNotifierService ' \
              'instead.'

        def_node_matcher :bugsnag_usage?, <<-PATTERN
          (send
            (const nil? :Bugsnag) :notify ...)
        PATTERN

        def_node_matcher :bugsnag_constant?, <<-PATTERN
          (const nil? :Bugsnag)
        PATTERN

        def on_send(node)
          if bugsnag_usage?(node)
            add_offense(node, message: MSG)
          end
        end

        def on_const(node)
          if bugsnag_constant?(node)
            add_offense(node, message: MSG)
          end
        end
      end
    end
  end
end
