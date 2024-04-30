# frozen_string_literal: true

module Mutations
  class CommentUpdate < BaseMutation
    description "Updates a comment by id"

    field :comment, Types::CommentType, null: false

    argument :id, ID, required: true
    argument :comment_input, Types::CommentInputType, required: true

    def resolve(id:, comment_input:)
      comment = ::Comment.find(id)
      raise GraphQL::ExecutionError.new "Error updating comment", extensions: comment.errors.to_hash unless comment.update(**comment_input)

      { comment: comment }
    end
  end
end
