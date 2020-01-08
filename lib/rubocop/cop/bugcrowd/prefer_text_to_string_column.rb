# frozen_string_literal: true

module RuboCop
  module Cop
    module Bugcrowd
      class PreferTextToStringColumn < RuboCop::Cop::Cop
        include Database

        MSG = 'Prefer text column to string, e.g. add_column :table, :column, :text. ' \
              'See https://www.depesz.com/2010/03/02/charx-vs-varcharx-vs-varchar-vs-text/'

        def_node_matcher :add_column_with_string?, <<-PATTERN
          (send nil? :add_column <(sym :string) ...>)
        PATTERN

        def_node_matcher :within_create_table_block?, <<-PATTERN
          (block #create_table? ...)
        PATTERN

        def_node_matcher :string_method_sent_to_var?, <<-PATTERN
          (send (lvar _var) :string ...)
        PATTERN

        def on_send(node)
          return unless within_change_or_up_method?(node)

          if add_column_with_string?(node)
            add_offense(node)
          elsif string_method_sent_to_var?(node)
            # blocks that have multiple expressions within them get wrapped
            # with a 'begin' type :shrug:
            parent = node.parent.begin_type? ? node.parent.parent : node.parent

            add_offense(node) if within_create_table_block?(parent)
          end
        end
      end
    end
  end
end
