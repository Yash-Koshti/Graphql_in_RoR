# frozen_string_literal: true

module Mutations
  class BlogUpdate < BaseMutation
    description "Updates a blog by id"

    field :blog, Types::BlogType, null: false

    argument :id, ID, required: true
    argument :blog_input, Types::BlogInputType, required: true

    def resolve(id:, blog_input:)
      blog = ::Blog.find(id)
      raise GraphQL::ExecutionError.new "Error updating blog", extensions: blog.errors.to_hash unless blog.update(**blog_input)

      { blog: blog }
    end
  end
end
