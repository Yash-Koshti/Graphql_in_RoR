# frozen_string_literal: true

module Mutations
  class CommentDelete < BaseMutation
    description "Deletes a comment by ID"

    field :comment, Types::CommentType, null: false

    argument :id, ID, required: true

    def resolve(id:)
      comment = ::Comment.find(id)
      raise GraphQL::ExecutionError.new "Error deleting comment", extensions: comment.errors.to_hash unless comment.destroy!

      { comment: comment }
    end
  end
end
