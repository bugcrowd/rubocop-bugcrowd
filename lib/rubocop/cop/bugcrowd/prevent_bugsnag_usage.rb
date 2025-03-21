# frozen_string_literal: true

module RuboCop
  module Cop
    module Bugcrowd
      class PreventBugsnagUsage < RuboCop::Cop::Base
        MSG = 'Do not use Bugsnag in the codebase, as its integration has been removed. ' \
              'Use ErrorTrackingService for reporting errors.'

        def on_send(node)
          add_offense(node, message: MSG) if node.receiver&.const_name == 'Bugsnag'
        end
      end
    end
  end
end
