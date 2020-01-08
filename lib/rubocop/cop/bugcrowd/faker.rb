# frozen_string_literal: true

module RuboCop
  module Cop
    module Bugcrowd
      module Faker
        extend RuboCop::NodePattern::Macros

        def_node_matcher :faker_const?, <<-PATTERN
          (const nil? :Faker)
        PATTERN

        # any method sent to Faker::Config or Faker::UniqueGenerator
        def_node_matcher :faker_config_classes?, <<-PATTERN
          (send (const #faker_const? {:Config :UniqueGenerator}) ...)
        PATTERN

        # any method sent to Faker e.g. Faker::Lorem.blah
        def_node_matcher :faker_call?, <<-PATTERN
          (send (const #faker_const? _any_generator) ...)
        PATTERN
      end
    end
  end
end
