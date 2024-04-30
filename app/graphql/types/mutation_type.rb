# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :comment_delete, mutation: Mutations::CommentDelete
    field :comment_update, mutation: Mutations::CommentUpdate
    field :comment_create, mutation: Mutations::CommentCreate
    field :blog_delete, mutation: Mutations::BlogDelete
    field :blog_update, mutation: Mutations::BlogUpdate
    field :blog_create, mutation: Mutations::BlogCreate
    field :user_delete, mutation: Mutations::UserDelete
    field :user_update, mutation: Mutations::UserUpdate
    field :user_create, mutation: Mutations::UserCreate
    # TODO: remove me
    field :test_field, String, null: false,
      description: "An example field added by the generator"
    def test_field
      "Hello World"
    end
  end
end
