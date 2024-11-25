# frozen_string_literal: true

module RuboCop
  module Cop
    module Bugcrowd
      class PreventReindexFullESDocumentCop < Base
        #
        # @example
        #
        # # bad
        # ```
        # Reindexing a full ES document would reindex all the resource ids
        # ```
        # ValisCommands::ReindexDocument.call(document_type: 'SubmissionDocument')
        #
        # # good
        # Reindex only a specific resource ID instead
        # ```
        # ValisReindexWorker.new.perform([submission.id], Submission.to_s)
        # ```
        #

        MSG = 'Avoid reindexing the full Elasticsearch document. ' \
        'Consider reindexing only specific resource ids.'

        def_node_matcher :valis_reindex_document?, <<-PATTERN
          (send
            (const
              (const nil? :ValisCommands) :ReindexDocument) :call
              (hash $...))
        PATTERN

        def on_send(node)
          if valis_reindex_document?(node)
            add_offense(node, message: MSG)
          end
        end
      end
    end
  end
end
