# frozen_string_literal: true

# TODO: when finished, run `rake generate_cops_documentation` to update the docs
module RuboCop
  module Cop
    module Bugcrowd
      #
      #   # bad
      #   thing = list_of_things.sample
      #   expect(thing).to have_some_property
      #
      #   # good
      #   list_of_things.each do |thing|
      #     expect(thing).to have_some_property
      #   end
      #
      #   # good
      #   expect(thing).to have_some_property
      #   expect(thing1).to have_some_property
      #
      class AvoidSampleInSpecs < Cop
        MSG = 'Avoid using sample in spec as it can cause non-deterministic behavior'

        def_node_matcher :sample?, <<~PATTERN
          (send ... :sample)
        PATTERN

        def on_send(node)
          return unless sample?(node)

          add_offense(node)
        end
      end
    end
  end
end
