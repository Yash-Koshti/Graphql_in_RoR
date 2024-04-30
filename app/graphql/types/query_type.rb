# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :node, Types::NodeType, null: true, description: "Fetches an object given its ID." do
      argument :id, ID, required: true, description: "ID of the object."
    end

    def node(id:)
      context.schema.object_from_id(id, context)
    end

    field :nodes, [Types::NodeType, null: true], null: true, description: "Fetches a list of objects given a list of IDs." do
      argument :ids, [ID], required: true, description: "IDs of the objects."
    end

    def nodes(ids:)
      ids.map { |id| context.schema.object_from_id(id, context) }
    end

    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    field :users, [Types::UserType], null: false, description: "It returns all the users"
    def users
      User.all
    end
    
    field :blogs, [Types::BlogType], null: false, description: "It returns all the blogs" do
      argument :user_id, ID, required: false
    end
    def blogs(user_id: nil)
      if user_id
        Blog.where(user_id: user_id)
      else
        Blog.includes(:user).all
      end
    end
    
    field :comments, [Types::CommentType], null: false, description: "It returns all the comments" do
      argument :blog_id, ID, required: false
    end
    def comments(blog_id: nil)
      if blog_id
        Comment.includes(:blog, :user).where(blog_id: blog_id)
      else
        Comment.includes(:blog, :user).all
      end
    end

    # TODO: remove me
    field :test_field, String, null: false,
      description: "An example field added by the generator"
    def test_field
      "Hello World!"
    end
  end
end
