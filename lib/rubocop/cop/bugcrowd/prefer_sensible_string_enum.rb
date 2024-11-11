# frozen_string_literal: true

module RuboCop
  module Cop
    module Bugcrowd
      #  SensibleStringEnum has a number of advantages over the built in Rails enum.
      #  1. Rails string enums are not supported very well. They are really meant for
      #     traditional integer enums -- which I've never actually seen used.
      #  2. Rails enums throw runtime exceptions when they are SET instead of at validation
      #  3. Rails enums add a ton of methods to the class they are added to, many of which are
      #     not very helpful
      #
      #   # bad
      #   enum source: { web: 'web', csv: 'csv' }
      #
      #   # good
      #   include SensibleStringEnum
      #
      #   enumerate_strings_for :source, [:web, :csv]
      #
      class PreferSensibleStringEnum < Base
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
