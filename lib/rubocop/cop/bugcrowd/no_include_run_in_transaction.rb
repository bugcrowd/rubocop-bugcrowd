# frozen_string_literal: true

module RuboCop
  module Cop
    module Bugcrowd
      #   Commands often need to publish events, so wrapping the whole thing in a transaction
      #   means that the event is published within the transaction. We prefer explicit
      #   transactions defined only where they need to go. Many event handlers run
      #   asynchronously which can cause them to run even when the action has been rolled back.
      #
      #   # bad
      #   class NewCommand
      #     include Interactor
      #     include RunInTransaction
      #     ...
      #   end
      #
      #   # good
      #   class NewCommand
      #     include Interactor
      #
      #     def call
      #       ActiveRecord::Base.transaction do
      #         ...
      #       end
      #     end
      #   end
      #

      class NoIncludeRunInTransaction < Base
        MSG = 'Prefer explicit transactions over wrapping entire command or organizer ' \
              'see: https://bugcrowd.atlassian.net/wiki/spaces/DEV/pages/589856783/How+to+use+activerecord+transactions'

        def_node_matcher :including_run_in_transaction?, <<~PATTERN
          (send nil? :include (const nil? :RunInTransaction))
        PATTERN

        def on_send(node)
          add_offense(node) if including_run_in_transaction?(node)
        end
      end
    end
  end
end
