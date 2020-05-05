# frozen_string_literal: true

module RuboCop
  module Cop
    module Bugcrowd
      class RequireOptionalForBelongsTo < RuboCop::Cop::Cop
        # Ensures that the :optional argument is supplied to the belongs_to method
        # to help with upgrading to the new rails default
        #
        # @example
        #
        # # bad
        # ```
        # class MyModel
        #   belongs_to :other_model
        # end
        # ```
        #
        # # bad
        # ```
        # class MyModel
        #   belongs_to :other_model, optional: nil
        # end
        # ```
        #
        # # good
        # ```
        # class MyModel
        #   belongs_to :other_model, optional: true
        # end
        # ```
        #
        # # good
        # ```
        # class MyModel
        #   belongs_to :other_model, optional: false
        # end
        # ```
        #
        MSG = 'Always specify whether belongs_to is optional using `optional: true/false`'

        def_node_matcher :belongs_to_with_optional?, <<-PATTERN
          (send nil? :belongs_to _+
            (hash
              <(pair (sym :optional) (!nil)) ...>
            )
          )
        PATTERN

        def_node_matcher :in_belongs_to?, <<-PATTERN
          (send nil? :belongs_to ...)
        PATTERN

        def on_send(node)
          if in_belongs_to?(node) && !belongs_to_with_optional?(node)
            add_offense(node)
          end
        end

        def autocorrect(node)
          lambda do |corrector|
            corrector.replace(
              node.last_argument.loc.expression,
              "#{node.last_argument.source}, optional: true"
            )
          end
        end
      end
    end
  end
end
