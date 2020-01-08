# frozen_string_literal: true

module RuboCop
  module Cop
    module Bugcrowd
      class PreferTextToStringColumn < RuboCop::Cop::Cop
        include Database

        MSG = <<~COPCONTENT
          Prefer text column to string, e.g. add_column :table, :column, :text. See https://www.depesz.com/2010/03/02/charx-vs-varcharx-vs-varchar-vs-text/
        COPCONTENT

        def_node_matcher :add_column_with_string?, <<-PATTERN
        (send nil? :add_column ... (sym :string))
        PATTERN

        def_node_matcher :string_method_sent_to_var?, <<-PATTERN
        (send (lvar _) :string ...)
        PATTERN

        def on_send(node)
          return unless within_change_or_up_method?(node)

          if add_column_with_string?(node)
            add_offense(node)
          elsif node.ancestors[0].begin_type? && string_method_sent_to_var?(node)
            # within a block and calling '[blockvar].string'
            add_offense(node)
          end
        end
    end
    end
end
end
