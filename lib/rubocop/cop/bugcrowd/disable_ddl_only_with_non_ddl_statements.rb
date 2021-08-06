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

        def on_send(node)
          within_change_or_up_method?(node) &&
            (statement_requires_ddl_transaction?(node) ||
              add_or_remove_index_without_concurrently?(node)) &&
            node.ancestors.any?(&method(:with_disable_ddl_transaction_set?)) &&
            add_offense(node)
        end
      end
    end
  end
end
