# frozen_string_literal: true

module RuboCop
  module Cop
    module Bugcrowd
      #   See https://thoughtbot.com/blog/how-to-create-postgres-indexes-concurrently-in
      #
      #   # bad
      #   add_index :table_name, [:derp, :dap], unique: true, algorithm: :flunflurrently
      #
      #   # bad
      #   add_index :table_name, :column_name, unique: true
      #
      #   # good
      #   add_index :table_name, [:derp, :dap], unique: true, algorithm: :concurrently
      #
      #   # good
      #   add_index :table_name, :column, zibble: :bibble, algorithm: :concurrently
      class DisableDdlOnlyWithNonDdlStatements < Cop
        include Database

        MSG = 'Only disable ddl transactions for non-ddl statements'

        # add_index

        def_node_matcher :ddl_method?, <<~PATTERN
          {:create_join_table :create_table :add_column :add_foreign_key :add_reference :add_timestamps :change_column :change_column_default :change_column_null :change_table :rename_column :rename_index :rename_table :drop_table :drop_join_table :remove_column :remove_columns :remove_foreign_key :remove_index :remove_index :remove_reference :remove_timestamps}
        PATTERN

        def_node_matcher :ddl_statement?, <<~PATTERN
          (send nil? #ddl_method? ...)
        PATTERN

        def_node_search :with_disable_ddl_transaction_set?, <<~PATTERN
          (send nil? :disable_ddl_transaction!)
        PATTERN

        def_node_matcher :add_index_with_concurrent?, <<~PATTERN
          (send nil? :add_index _ _
            (hash
              <(pair (sym :algorithm) (sym :concurrently)) ...>
            )
          )
        PATTERN

        def_node_matcher :add_index?, <<~PATTERN
          (send nil? :add_index ...)
        PATTERN

        def on_send(node)
          within_change_or_up_method?(node) &&
            (ddl_statement?(node) || add_index_without_concurrently?(node)) &&
            node.ancestors.any?(&method(:with_disable_ddl_transaction_set?)) &&
            add_offense(node)
        end

        def add_index_without_concurrently?(node)
          add_index?(node) && !add_index_with_concurrent?(node)
        end
      end
    end
  end
end
