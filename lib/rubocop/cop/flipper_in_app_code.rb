# frozen_string_literal: true

module BugcrowdCops
  class FlipperInAppCode < RuboCop::Cop::Cop
    MSG = <<~COPCONTENT
      Generally we want to avoid setting flippers in code.
      Flippers should be temporary and used for strategic rollouts, not persistence -- use real databases instead

      When using flipper in specs, use the with_feature helper

      describe 'usage' do
        let(:user) {  create(:user)}
        with_feature(:some_awesome_feature, actor: :user)
        with_feature(:some_awesome_feature, actor: :user) do
          it {...}
        end
      end
    COPCONTENT

    def_node_matcher :flipper_enable?, <<-PATTERN
        (send (send (gvar #flipper_gvar?) :[] _) {:enable :disable} ...)
    PATTERN

    def on_send(node)
      return unless flipper_enable?(node)

      add_offense(node)
    end

    private

    # node matcher DSL considers '$' a special character so we need this
    def flipper_gvar?(sym)
      sym == :$flipper
    end
  end
end
