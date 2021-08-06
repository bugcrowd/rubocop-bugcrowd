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

        def add_or_remove_index_without_concurrently?(node)
          (add_index?(node) && !add_index_concurrently?(node)) ||
            (remove_index?(node) && !remove_index_concurrently?(node))
        end

        def_node_matcher :create_table?, <<-PATTERN
          (send nil? :create_table ...)
        PATTERN

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

        def_node_matcher :add_index?, <<~PATTERN
          (send nil? :add_index ...)
        PATTERN

        def_node_matcher :add_index_concurrently?, <<~PATTERN
          (send nil? :add_index _ _
            (hash
              <(pair (sym :algorithm) (sym :concurrently)) ...>
            )
          )
        PATTERN

        def_node_matcher :remove_index?, <<~PATTERN
          (send nil? :remove_index ...)
        PATTERN

        def_node_matcher :remove_index_concurrently?, <<~PATTERN
          (send nil? :remove_index _ _
            (hash
              <(pair (sym :algorithm) (sym :concurrently)) ...>
            )
          )
        PATTERN

        def_node_matcher :requires_ddl_transaction_method?, <<~PATTERN
          {:create_join_table :create_table :add_column :add_foreign_key :add_reference :add_timestamps :change_column :change_column_default :change_column_null :change_table :rename_column :rename_index :rename_table :drop_table :drop_join_table :remove_column :remove_columns :remove_foreign_key :remove_reference :remove_timestamps}
        PATTERN

        def_node_matcher :ddl_statement?, <<~PATTERN
          (send nil? #requires_ddl_transaction_method? ...)
        PATTERN

        def_node_search :with_disable_ddl_transaction_set?, <<~PATTERN
          (send nil? :disable_ddl_transaction!)
        PATTERN
      end
    end
  end
end
