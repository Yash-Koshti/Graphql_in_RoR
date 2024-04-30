# frozen_string_literal: true

module Types
  class CommentInputType < Types::BaseInputObject
    argument :message, String, required: false
    argument :blog_id, Integer, required: false
    argument :user_id, Integer, required: false
    argument :updated_at, GraphQL::Types::ISO8601DateTime, required: false
  end
end
