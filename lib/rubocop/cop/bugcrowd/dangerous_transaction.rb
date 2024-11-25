# frozen_string_literal: true

# TODO: when finished, run `rake generate_cops_documentation` to update the docs
module RuboCop
  module Cop
    module Bugcrowd
      class DangerousTransaction < Base
        MSG = "Use ProperTransaction.start instead of ActiveRecord's base, " \
              'class, or instance-level transaction methods. See ' \
              'https://bugcrowd.atlassian.net/wiki/spaces/DEV/blog/2020/03/24/1126006819/' \
              'Learnings+-+Nested+Transactions+in+Rails' \
              ' for more background'

        def_node_matcher :consts_that_transaction_may_be_called_on, <<-PATTERN
          {(send (const nil? _) :transaction ...) (send (const (const nil? :ActiveRecord) :Base) :transaction ...)}
        PATTERN

        def_node_matcher :transaction_called_in_a_safe_way?, <<~PATTERN
          (send (const (const nil? :ActiveRecord) :Base) :transaction
            (hash
              (pair
                (sym :joinable)
                (false))
              (pair
                (sym :requires_new)
                (true))
            )
          )
        PATTERN

        def on_send(node)
          if consts_that_transaction_may_be_called_on(node) &&
             !transaction_called_in_a_safe_way?(node)
            add_offense(node)
          end
        end
      end
    end
  end
end
