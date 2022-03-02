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
      #   page.driver.wait_for_network_idle
      #   expect(page).to have_content('blah')
      #
      #   # good
      #   expect(page).to have_content('blah', wait: 3)
      #
      # use wait_for_network_idle when waiting for network requests
      #
      # https://github.com/rubycdp/cuprite#network-traffic
      # https://github.com/rubycdp/ferrum#wait_for_idleoptions
      #
      # use wait when waiting for frontend only animations
      # https://github.com/teamcapybara/capybara#asynchronous-javascript-ajax-and-friends
      # https://www.varvet.com/blog/why-wait_until-was-removed-from-capybara/
      # https://www.reddit.com/r/rails/comments/25xrdy/is_there_a_way_to_change_capybaras_wait_time_just/
      #
      # Other method of avoiding sleep:
      #
      # 1. Don't rely on something that is inherently slow
      #   - instead of waiting for the page to be updated you can check
      #     that the correct behavior is called
      #     (this can sometimes make the test less robust)
      class SleepySpecs < RuboCop::Cop::Cop
        MSG = <<~COPCONTENT
          🚨  Do not use sleep, wait_for_network_idle or wait instead 🚨
          Sleep will wait for the given amount of time whether or not it needs to,
          wait_for_network_idle natively waits for network idle,
          wait will only wait until the matcher is found.
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
