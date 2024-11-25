# frozen_string_literal: true

module RuboCop
  module Cop
    module Bugcrowd
      class NoEventDeprecatedPublish < Base
        #   The way we publish events, we don't want to publish the event externally if the
        #   transaction triggering it has been rolled back.  We also don't want the event to be
        #   rolled back in the case that processing the event fails so we do not lose record of
        #   the original event.  Instead of saving and publishing the event in the same call you
        #   should save the new event first, then publish it.
        #
        #   # bad
        #   ActiveRecord::Base.transaction do
        #     new_record.save!
        #     EventStore.deprecated_publish(resource: new_record, data: { blah: 'string' })
        #   end
        #
        #   # good
        #   ActiveRecord::Base.transaction do
        #     new_record.save!
        #     new_event = Event.create!(resource: new_record, data: { blah: 'string' })
        #   end
        #   new_event.publish!
        #
        MSG = 'Prefer the new form of saving the event first within the same transaction as ' \
              'the data mutation, then calling `new_event.publish!` outside of the transaction.'

        def_node_matcher :using_deprecated_publish?, <<~PATTERN
          (send (const nil? :EventStore) :deprecated_publish ...)
        PATTERN

        def on_send(node)
          add_offense(node) if using_deprecated_publish?(node)
        end
      end
    end
  end
end
