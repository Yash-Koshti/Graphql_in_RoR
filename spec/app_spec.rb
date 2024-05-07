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

      it "should not return nil if have some users" do
        FactoryBot.build(:user)

        # pp "---Query---"
        # pp "Error message: #{result("errors", 0, "message")}" unless result["data"]
        # pp "Data_dig: #{data_dig}"

        expect(data_dig("users")).not_to be_nil
      end
    end
  end

  describe "mutation" do
    context "create user" do
      dummy_user = FactoryBot.attributes_for(:user)
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
        # pp "---Create---"
        # pp "Dummy_user: #{dummy_user}"
        # pp "Error message: #{result("errors", 0, "message")}" unless result["data"]
        # pp "Data_dig: #{data_dig}"

        expect(data_dig("userCreate", "user")).to include(
          "userName" => dummy_user[:user_name],
          "email" => dummy_user[:email],
        )
      end
    end

    context "update user" do
      let(:dummy_user) { FactoryBot.create(:user) }
      let(:query_string) do
        <<~GQL
          mutation {
            userUpdate(input: {
              id: #{dummy_user.id},
              userInput: {
                userName: "testing Update",
                email: "update.complete@test.com"
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

      it "should update user_name and email" do
        # pp "---Update---"
        # pp "Dummy_user: #{dummy_user}, Id: #{dummy_user.id}, Name: #{dummy_user.user_name}"
        # pp "Error message: #{result["errors"][0]["message"]}" unless result["data"]
        # pp "Data_dig: #{data_dig}"

        expect(User.find(dummy_user.id).user_name).to eq "testing Update"
        expect(data_dig("userUpdate", "user")).to include(
          "id" => dummy_user.id.to_s,
          "userName" => "testing Update",
          "email" => "update.complete@test.com",
        )
      end
    end
    #database cleaner active records: This is used to clean database.
    context "delete user" do
      let(:dummy_user) { FactoryBot.create(:user) }
      let(:query_string) do
        <<~GQL
          mutation{
            userDelete(input: {
              id: #{dummy_user.id}
            }){
              user{
                id
              }
            }
          }
        GQL
      end

      it "should delete user" do
        # pp "---Delete---"
        # pp "Dummy_user: #{dummy_user}, Id: #{dummy_user.id}"
        # pp "Error message: #{result["errors"][0]["message"]}" unless result["data"]
        # pp "Data_dig: #{data_dig}"
        expect(data_dig("userDelete", "user")).to include("id" => dummy_user.id.to_s)
      end
    end
  end
end
