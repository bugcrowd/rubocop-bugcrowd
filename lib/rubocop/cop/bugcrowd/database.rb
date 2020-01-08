# frozen_string_literal: true

module RuboCop
  module Cop
    module Bugcrowd
      module Database
        extend RuboCop::NodePattern::Macros

        private

        def within_change_or_up_method?(node)
          node.each_ancestor(:def).any? do |ancestor|
            ancestor.method?(:change) || ancestor.method?(:up)
          end
        end

        def_node_matcher :create_table_with_uuid_pk?, <<-PATTERN
      (send nil? :create_table _
        (hash
          (pair
            (sym :id)
            (sym :uuid)
          )
        )
      )
        PATTERN
      end
    end
  end
end
