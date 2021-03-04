# frozen_string_literal: true

module RuboCop
  module Cop
    module Bugcrowd
      class SidekiqTestingInline < Cop
        #   Sidekiq::Testing.inline! can cause huge cascade of handlers to be called.
        #   When you use inline! Valis workers are triggered without you realizing,
        #   which create indexes that are not cleaned up by subsequent specs.
        #   This could probably be fixed by other means, but draining the queue
        #   you know you need to drain is probably the better solution in most situations.
        #
        #   # bad
        #   Sidekiq::Testing.inline! do
        #     subject
        #   end
        #
        #   # bad
        #   Sidekiq::Testing.inline! { subject }
        #
        #   # good
        #   subject
        #   FeatureICareAboutWorker.drain
        #
        MSG = 'Prefer to drain the worker, then calling `Sidekiq::Testing.inline!`'

        def_node_matcher :using_sidekiq_test_in_inline?, <<~PATTERN
          (send (const (const nil? :Sidekiq) :Testing) :inline! ...)
        PATTERN

        def on_send(node)
          add_offense(node) if using_sidekiq_test_in_inline?(node)
        end
      end
    end
  end
end
