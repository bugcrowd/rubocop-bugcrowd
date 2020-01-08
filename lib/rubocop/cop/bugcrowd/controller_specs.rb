# frozen_string_literal: true

module RuboCop
  module Cop
    module Bugcrowd
      class ControllerSpecs < RuboCop::Cop::Cop
        MSG = <<~COPCONTENT
          🚨  Controller specs are deprecated, please create request specs instead 🚨
          See https://everydayrails.com/2016/08/29/replace-rspec-controller-tests.html for an overview
          See DHH's original conversation of the 'why' here https://github.com/rails/rails/issues/18950
        COPCONTENT

        def_node_matcher :describe_block?, <<-PATTERN
        {(send (const nil? :RSpec) :describe ...) (send nil? :describe ...)}
        PATTERN

        def on_send(node)
          add_offense(node) if describe_block? node
        end
    end
    end
end
end
