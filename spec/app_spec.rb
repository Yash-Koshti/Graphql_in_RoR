# frozen_string_literal: true
require "rails_helper"
require "graphql_helper"

RSpec.describe "user spec", type: :request do
  let(:context) { {} }
  let(:variables) { {} }
  let(:result) { execute_graphql_test }

  describe "query" do
    context "fetch all users" do
      let(:query_string) do
        <<~GQL
          query {
            users{
              id
              userName
              email
            }
          }
        GQL
      end
      it "should initially return nil" do
        pp "Error message: #{result["errors"][0]["message"]}" unless result["data"]
        pp "Data_dig: #{data_dig}"

        expect(data_dig("users")).to eq []
      end

      it "should not return nil if have some users" do
        FactoryBot.create(:user)

        pp "Error message: #{result["errors"][0]["message"]}" unless result["data"]
        pp "Data_dig: #{data_dig}"

        expect(data_dig("users")).not_to be_nil
      end
    end
  end

  describe "mutation" do
    context "create user" do
      let(:dummy_user) { FactoryBot.attributes_for(:user) }
      let(:query_string) do
        <<~GQL
            mutation {
              userCreate(input: {
                userInput: {
                  userName: "#{dummy_user[:user_name]}",
              email: "#{dummy_user[:email]}"
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

      it "should return newly created user" do
        pp "Dummy_user: #{dummy_user}"
        pp "Error message: #{result["errors"][0]["message"]}" unless result["data"]
        pp "Data_dig: #{data_dig}"

        expect(data_dig("userCreate", "user")).to include(
          "userName" => dummy_user[:user_name],
          "email" => dummy_user[:email],
        )
      end
    end
  end
end
