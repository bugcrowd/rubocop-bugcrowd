# frozen_string_literal: true

module RuboCop
  module Cop
    module Bugcrowd
      #   # bad
      #   class DerpMigration < ActiveRecord::Migration[5.2]
      #     disable_ddl_transaction!
      #
      #     def change
      #       add_column(:table_name, :offensive_name)
      #     end
      #   end
      #
      #   # good
      #   class DerpMigration < ActiveRecord::Migration[5.2]
      #     disable_ddl_transaction!
      #     def change
      #       add_index :table_name, :column_name, unique: true, algorithm: :concurrently
      #     end
      #   end
      class DisableDdlOnlyWithNonDdlStatements < Cop
        include Database

        MSG = 'Only disable ddl transactions for non-ddl statements'

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
          add_index?(node) && !add_index_concurrently?(node)
        end
      end
    end
  end
end
