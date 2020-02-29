# frozen_string_literal: true

module RuboCop
  module Cop
    module Bugcrowd
      class UuidColumnRequired < RuboCop::Cop::Cop
        include Database

        MSG = <<~COPCONTENT
          \nNew tables should all have a uuid column of type uuid \n
          Example: `t.uuid :uuid, null: false, default: 'gen_random_uuid()', index: { unique: true }`
          This is a temporary cop to help with the uuid migration:\n
          https://github.com/bugcrowd/crowdcontrol/pull/8730
        COPCONTENT

        def_node_search :create_table_with_uuid_column?, <<-PATTERN
          (send (lvar _) :uuid (sym :uuid) ...)
        PATTERN

        def_node_search :uuid_column_has_all_the_necessary_directives?, <<-PATTERN
          (send (lvar _) :uuid (sym :uuid)
            (hash
              (pair
                (sym :null)
                (false))
              (pair
                (sym :default)
                (str "gen_random_uuid()"))
              (pair
                (sym :index)
                (hash
                  (pair
                    (sym :unique)
                    (true))))))
        PATTERN

        def on_send(node)
          if within_change_or_up_method?(node) && create_table?(node) &&
             !create_table_with_uuid_pk?(node) && create_table_with_uuid_column?(node.parent) &&
             !uuid_column_has_all_the_necessary_directives?(node.parent)
            add_offense(node)
          end
        end
      end
    end
  end
end
