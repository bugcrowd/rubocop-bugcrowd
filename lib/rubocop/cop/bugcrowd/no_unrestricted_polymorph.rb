# frozen_string_literal: true

module RuboCop
  module Cop
    module Bugcrowd
      class NoUnrestrictedPolymorph < RuboCop::Cop::Cop
        # Ensures that the `polymorphic_belongs_to` method from SafePolymorphic is used instead
        # of the `polymorphic: true` option for `belongs_to`
        #
        # @example
        #
        # # bad
        # ```
        # class MyModel
        #   belongs_to :other_model, polymorphic: true
        # end
        # ```
        #
        # # bad
        # ```
        # class MyModel
        #   belongs_to :other_model, class_name: 'Other', polymorphic: true, optional: false
        # end
        # ```
        #
        # # good
        # ```
        # class MyModel
        #   belongs_to :other_model
        # end
        # ```
        #
        # # good
        # ```
        # class MyModel
        #   polymorphic_belongs_to :other_model, allowed_constants: [:Other, :Another]
        # end
        # ```
        #
        MSG = 'Always use `SafePolymorphic#polymorphic_belongs_to`' \
              ' to define polymorphic relationships'

        def_node_matcher :belongs_to_with_polymorphic?, <<-PATTERN
          (send nil? :belongs_to _+
            (hash
              <(pair (sym :polymorphic) (_)) ...>
            )
          )
        PATTERN

        def on_send(node)
          add_offense(node) if belongs_to_with_polymorphic?(node)
        end
      end
    end
  end
end
