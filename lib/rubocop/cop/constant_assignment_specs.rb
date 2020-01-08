# frozen_string_literal: true

module BugcrowdCops
  class ConstantAssignmentSpecs < RuboCop::Cop::Cop
    MSG = <<~COPCONTENT
      🚨  Constants persist across specs due to global nature 🚨
    COPCONTENT

    def on_casgn(node)
      add_offense(node)
    end
  end
end
