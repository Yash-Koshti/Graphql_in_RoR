# frozen_string_literal: true
require "rails_helper"
require "graphql_helper"

# query {
#             users{
#                 id
#                 userName
#                 email
#             }
#         }

RSpec.describe "user spec", type: :request do
  let(:context) { {} }
  let(:variables) { {} }
  let(:subject) { execute_graphql_test }
  describe "fetch users" do
    let(:dummy_user) { FactoryBot.create(:user) }
    let(:query_string) do
      <<~GQL
        mutation {
          userCreate(input: {
            userInput: {
                userName: #{dummy_user.user_name},
                email: #{dummy_user.email}
              }
          }){
            user {
              id
              userName
              email
              createdAt
              updatedAt
            }
          }
        }
      GQL
    end

    it "should return all users" do
      pp "Dummy_user: #{dummy_user}"
      pp "\nSubject: #{subject}"

      expect(data_dig).to eq []
    end
  end
end
