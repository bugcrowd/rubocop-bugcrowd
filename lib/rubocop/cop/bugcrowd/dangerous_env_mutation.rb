# frozen_string_literal: true

module RuboCop
  module Cop
    module Bugcrowd
      # @example
      #   # bad
      #   ENV['blah'] = 'zah'
      #
      #   # good
      #   allow(ENV).to receive(:[]).with('blah').and_return 'zah'
      #
      #   # good
      #   allow(Rails.configuration.x).to receive(blah).and_return 'zah'
      class DangerousEnvMutation < Cop
        MSG = 'Stub ENV or use configuration objects instead of ' \
              'directly modifying global ENV state'

        def_node_matcher :bad_method?, <<~PATTERN
          (send (const nil? :ENV) :[]= (str _) ...)
        PATTERN

        def on_send(node)
          return unless bad_method?(node)

          add_offense(node)
        end
      end
    end
  end
end
