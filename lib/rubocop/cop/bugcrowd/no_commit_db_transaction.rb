# frozen_string_literal: true

module RuboCop
  module Cop
    module Bugcrowd
      class NoCommitDbTransaction < RuboCop::Cop::Cop
        include Database

        MSG = <<~COPCONTENT
          🚨 🚨 🚨 Don't use 'commit_db_transaction'. See https://bugcrowd.atlassian.net/wiki/spaces/DEV/pages/789708817/Database+Migrations
        COPCONTENT

        def_node_matcher :commit_db_transaction?, <<-PATTERN
        (send nil? :commit_db_transaction)
        PATTERN

        def on_send(node)
          add_offense(node) if within_change_or_up_method?(node) && commit_db_transaction?(node)
        end
    end
    end
end
end
