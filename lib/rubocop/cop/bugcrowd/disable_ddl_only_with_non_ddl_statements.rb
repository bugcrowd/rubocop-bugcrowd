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

        def_node_matcher :with_disable_ddl_transaction_set?, <<~PATTERN
          (send nil? :create_table ...)
        PATTERN


        def on_send(node)
          binding.pry
          if within_change_or_up_method?(node) 
            binding.pry
            if ddl_statement?(node)
              binding.pry
              if with_disable_ddl_transaction_set?(node)
                add_offense(node)
              end
            end
          end
        end
      end
    end
  end
end
