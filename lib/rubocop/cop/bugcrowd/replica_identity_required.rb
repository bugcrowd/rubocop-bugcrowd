# frozen_string_literal: true

module RuboCop
  module Cop
    module Bugcrowd
      class ReplicaIdentityRequired < Base
        extend AutoCorrector

        # Checks that tables have a replica identity defined
        #
        # @example
        #
        # # bad
        #  ```
        #  def change
        #    create_table :new_table_name, id: :uuid do |t|
        #      t.text :name, null: false
        #    end
        #  end
        #  ```
        #
        # # good
        #  ```
        #  def change
        #    create_table :new_table_name, id: :uuid do |t|
        #      t.text :name, null: false
        #    end
        #    set_replica_identity(:full)
        #  end
        #  ```

        MSG = 'tables should have `set_replica_identity` called after `create_table`, ' \
         'probably with set_replica_identity(:table_name, :full)'

        def within_change_or_up_method?(node)
          node.each_ancestor(:def).any? do |ancestor|
            ancestor.method?(:change) || ancestor.method?(:up)
          end
        end

        def_node_matcher :create_table?, <<-PATTERN
          (send nil? :create_table ...)
        PATTERN

        def calls_set_replica_identity?(node)
          node.parent.parent.each_descendant(:send).any? do |child|
            child.method?(:set_replica_identity)
          end
        end

        def on_send(node)
          # look for an `up` or `change` node with `create_table` but not `set_replica_identity`
          if within_change_or_up_method?(node) && create_table?(node) &&
             !calls_set_replica_identity?(node)
            add_offense(node) do |corrector|
              indent = node.source_range.source_line[/^(\s+)/] || ''
              corrector.insert_after(
                node.parent,
                "\n#{indent}set_replica_identity(:#{node.arguments[0].value}, :full)"
              )
            end
          end
        end
      end
    end
  end
end
