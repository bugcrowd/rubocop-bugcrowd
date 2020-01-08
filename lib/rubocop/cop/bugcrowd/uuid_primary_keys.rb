# frozen_string_literal: true

module RuboCop
  module Cop
    module Bugcrowd
      class UuidPrimaryKeys < RuboCop::Cop::Cop
        include Database

        MSG = <<~COPCONTENT
          \nNew tables should use integers as primary keys 🚨 UNLESS 🚨 these records need to be the actor for an Events (because Event.actor_id cannot accept integers)\n
          You may manually disable this cop once you understand the above considerations and have read\n
          https://bugcrowd.atlassian.net/wiki/spaces/DEV/pages/182321286/Tech+Debt#TechDebt-ConvertPKsToUUID for more details\n
        COPCONTENT

        def on_send(node)
          if within_change_or_up_method?(node) && create_table_with_uuid_pk?(node)
            add_offense(node)
            end
        end
    end
    end
end
end
