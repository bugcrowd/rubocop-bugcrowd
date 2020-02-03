# frozen_string_literal: true

# TODO: when finished, run `rake generate_cops_documentation` to update the docs
module RuboCop
  module Cop
    module Bugcrowd
      # TODO: Write cop description and example of bad / good code. For every
      # `SupportedStyle` and unique configuration, there needs to be examples.
      # Examples must have valid Ruby syntax. Do not use upticks.
      #
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
      # @example EnforcedStyle: foo
      #   # Description of the `foo` style.
      #
      #   # bad
      #   bad_foo_method
      #
      #   # bad
      #   bad_foo_method(args)
      #
      #   # good
      #   good_foo_method
      #
      #   # good
      #   good_foo_method(args)
      #
      class RailsConfigurationMutation < Cop
        # TODO: Implement the cop in here.
        #
        # In many cases, you can use a node matcher for matching node pattern.
        # See https://github.com/rubocop-hq/rubocop/blob/master/lib/rubocop/node_pattern.rb
        #
        # For example
        MSG = 'Avoid modifying rails configuration directly in specs, use stubbing instead'

        def setter?(method_name)
          method_name.to_s.end_with?('=')
        end

        def_node_matcher :is_setter?, <<~PATTERN
          (send _ #setter? ...)
        PATTERN

        def_node_search :is_rails_application_config?, <<~PATTERN
          (send (send (const nil? :Rails) :application) :config)
        PATTERN

        def_node_search :is_rails_config?, <<~PATTERN
          (send (const nil? :Rails) :configuration)
        PATTERN

        def on_send(node)
          return unless is_setter?(node)

          if is_rails_config?(node) || is_rails_application_config?(node)
            add_offense(node)
          end
        end
      end
    end
  end
end
