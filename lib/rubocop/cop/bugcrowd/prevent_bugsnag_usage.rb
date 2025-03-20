# frozen_string_literal: true

module RuboCop
  module Cop
    module Bugcrowd
      class PreventBugsnagUsage < RuboCop::Cop::Base
        MSG = 'Avoid using Bugsnag in the codebase. ' \
              'It has been replaced with ErrorNotifierService for error ' \
              'notification handling. Please use ErrorNotifierService instead.'

        def on_send(node)
          add_offense(node, message: MSG) if node.receiver&.const_name == 'Bugsnag'
        end
      end
    end
  end
end
