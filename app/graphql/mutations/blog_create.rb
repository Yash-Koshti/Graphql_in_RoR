# frozen_string_literal: true

module Mutations
  class BlogCreate < BaseMutation
    description "Creates a new blog"

    field :blog, Types::BlogType, null: false

    argument :blog_input, Types::BlogInputType, required: true

    def resolve(blog_input:)
      blog = ::Blog.new(**blog_input)
      raise GraphQL::ExecutionError.new "Error creating blog", extensions: blog.errors.to_hash unless blog.save

      { blog: blog }
    end
  end
end
