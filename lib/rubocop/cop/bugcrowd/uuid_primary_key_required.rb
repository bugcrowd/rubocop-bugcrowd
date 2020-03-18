# frozen_string_literal: true

module RuboCop
  module Cop
    module Bugcrowd
      class UuidPrimaryKeyRequired < RuboCop::Cop::Cop
        include Database

        # Checks that tables are created with uuid primary keys
        #
        # @example
        #
        # # bad
        #  ```
        #  create_table :new_table_name do |t|
        #    t.text :name, null: false
        #  end
        # ```
        #
        # # bad
        #  ```
        #  create_table :new_table_name, id: :integer do |t|
        #    t.text :name, null: false
        #  end
        # ```
        #
        # # good
        #  ```
        #  create_table :new_table_name, id: :uuid do |t|
        #    t.text :name, null: false
        #  end
        # ```
        #

        MSG = 'All tables should all have a primary key of type :uuid'

        def creating_table_without_uuid_pk?(node)
          within_change_or_up_method?(node) && create_table?(node) &&
            !create_table_with_uuid_pk?(node)
        end

        def on_send(node)
          if creating_table_without_uuid_pk?(node)
            add_offense(node)
          end
        end
      end
    end
  end
end
