# frozen_string_literal: true

module RuboCop
  module Cop
    module Bugcrowd
      class FakerWithoutUnique < RuboCop::Cop::Cop
        include Faker

        MSG = <<~COPCONTENT
          🚨 Don't use Faker without #unique 🚨
          When Faker is used under the hood through FactoryBot in specs, Faker can generate duplicate values, causing intermittency
          Replace all calls to Faker generators with `Faker::{Generator}.unique.{generator_method}`
        COPCONTENT

        # any method sent to Faker e.g. Faker::Lorem.blah
        def_node_matcher :faker_call_without_unique?, <<-PATTERN
          (send (const #faker_const? _any_generator) !:unique ...)
        PATTERN

        def on_send(node)
          add_offense(node) if !faker_config_classes?(node) && faker_call_without_unique?(node)
        end
      end
    end
  end
end
