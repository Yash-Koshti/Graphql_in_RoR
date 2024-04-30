# frozen_string_literal: true

module Types
  class BlogInputType < Types::BaseInputObject
    argument :title, String, required: false
    argument :content, String, required: false
    argument :user_id, Integer, required: false
    argument :updated_at, GraphQL::Types::ISO8601DateTime, required: false
  end
end
