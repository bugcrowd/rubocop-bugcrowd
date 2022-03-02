# frozen_string_literal: true

module RuboCop
  module Cop
    module Bugcrowd
      # @example
      #   # bad
      #   sleep 1
      #   expect(page).to have_content('blah')
      #
      #   # good
      #    page.driver.wait_for_network_idle
      #   expect(page).to have_content('blah')
      #
      # https://github.com/rubycdp/cuprite#network-traffic
      # https://github.com/rubycdp/ferrum#wait_for_idleoptions
      #
      #
      # Other method of avoiding sleep:
      # 1. Don't rely on something that is inherently slow
      #   - instead of waiting for the page to be updated you can check
      #     that the correct behavior is called
      #     (this can sometimes make the test less robust)
      class SleepySpecs < RuboCop::Cop::Cop
        MSG = <<~COPCONTENT
          🚨  Do not use sleep, use page.driver.wait_for_network_idle instead 🚨
          Sleep will wait for the given amount of time whether or not it needs to,
          wait_for_network_idle Natively waits for network idle.
          https://github.com/rubycdp/cuprite#network-traffic
        COPCONTENT

        def_node_matcher :sleeping?, <<-PATTERN
        (send nil? :sleep (...))
        PATTERN

        def on_send(node)
          return unless sleeping?(node)

          add_offense(node)
        end
      end
    end
  end
end
