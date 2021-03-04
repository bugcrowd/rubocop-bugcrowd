# frozen_string_literal: true

module RuboCop
  module Cop
    module Bugcrowd
      #
      #   # bad
      #   enum source: { web: 'web', csv: 'csv' }
      #
      #   # good
      #   include SensibleStringEnum
      #
      #   enumerate_strings_for :source, [:web, :csv]
      #
      class PreferSensibleStringEnum < Cop
        MSG = 'Prefer SensibleStringEnum over built in Rails enum.'

        def_node_matcher :enum?, <<~PATTERN
          (send nil? :enum ...)
        PATTERN

        def on_send(node)
          return unless enum?(node)

          add_offense(node)
        end
      end
    end
  end
end
