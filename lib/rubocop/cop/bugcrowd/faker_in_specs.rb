# frozen_string_literal: true

module RuboCop
  module Cop
    module Bugcrowd
      class FakerInSpecs < Base
        include Faker

        MSG = <<~COPCONTENT
          🚨 Don't use Faker in specs -- can cause non-determinism 🚨
          See https://gist.github.com/maschwenk/59d7ea7d8a40bec6621f47723cec602d for more details
        COPCONTENT

        def on_send(node)
          add_offense(node) if !faker_config_classes?(node) && faker_call?(node)
        end
      end
    end
  end
end
