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
      class AddIndexNonConcurrently < Cop
        include Database

        MSG = 'By default, Postgres locks writes to a table while creating an index on it ' \
              ' -- always add indexes concurrently, ' \
              'e.g. add_index :table_name, :column, algorithm: :concurrently'

        def_node_matcher :add_index?, <<~PATTERN
          (send nil? :add_index ...)
        PATTERN

        def_node_matcher :add_index_with_concurrent?, <<~PATTERN
          (send nil? :add_index _ _ <(sym :algorithm) (sym :concurrently) ...>)
        PATTERN

        def on_send(node)
          within_change_or_up_method?(node) &&
            add_index?(node) &&
            !add_index_with_concurrent?(node) &&
            add_offense(node)
        end
      end
    end
  end
end
