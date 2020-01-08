# frozen_string_literal: true

module RuboCop
  module Cop
    module Bugcrowd
      class DeprecateAms < RuboCop::Cop::Cop
        MSG = <<~COPCONTENT
          🚨 ActiveModelSerializers are slow, unmaintained, and deprecated in our app. Please use Presenters (app/presenters) instead. 🚨
        COPCONTENT

        def_node_matcher :ams_subclass?, <<-PATTERN
        (class (const nil? _) (const (const nil? :ActiveModel) :Serializer) ...)
        PATTERN

        def on_class(node)
          add_offense(node) if ams_subclass?(node)
        end
    end
    end
end
end
