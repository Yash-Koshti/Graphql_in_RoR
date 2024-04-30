# frozen_string_literal: true

module Types
  class UserInputType < Types::BaseInputObject
    argument :user_name, String, required: false
    argument :email, String, required: false
    argument :updated_at, GraphQL::Types::ISO8601DateTime, required: false
  end
end
