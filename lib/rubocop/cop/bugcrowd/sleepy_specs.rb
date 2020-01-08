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
      #   expect(page).to have_content('blah', wait: 3)
      #
      # https://github.com/teamcapybara/capybara#asynchronous-javascript-ajax-and-friends
      # https://www.varvet.com/blog/why-wait_until-was-removed-from-capybara/
      # https://www.reddit.com/r/rails/comments/25xrdy/is_there_a_way_to_change_capybaras_wait_time_just/
      #
      #
      # Other methods of avoiding sleep:
      # 1. Use an intermediate matcher
      # ```
      # expect(page).to have_content(flash_mesage) # the fast action
      # expect(page).to have_content(activity_message) # the slow action
      # ```
      # 2. Don't rely on something that is inherently slow
      #   - instead of waiting for the page to be updated you can check that the correct behavior
      #     is called (this can sometimes make the test less robust)
      class SleepySpecs < RuboCop::Cop::Cop

          # 🚨  Do not use sleep, use wait instead 🚨
          # Sleep will wait for the given amount of time whether or not it needs to,
          # wait will only wait until the matcher is found.
          # https://semaphoreci.com/community/tutorials/5-tips-for-more-effective-capybara-tests
        MSG = <<~COPCONTENT
          bizzle
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
