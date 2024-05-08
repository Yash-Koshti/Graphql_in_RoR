require "rails_helper"
require "graphql_helper"

RSpec.describe "Users", type: :request do
  let(:context) { {} }
  let(:variables) { {} }
  let(:result) { execute_graphql_test }

  describe "query" do
    context "users" do
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
    context "userCreate" do
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

    context "userUpdate" do
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
              }
            }
          }
        GQL
      end

      it "should update user_name and email" do
        user_returned_from_query = data_dig("userUpdate", "user")
        user_found_in_db = User.find(dummy_user.id)

        # pp "---Update---"
        # pp "Dummy_user: #{dummy_user}, Id: #{dummy_user.id}, Name: #{dummy_user.user_name}"
        # pp "Error message: #{result["errors"][0]["message"]}" unless result["data"]
        # pp "Data_dig: #{data_dig}"

        expect(user_returned_from_query).to include(
          "id" => dummy_user.id.to_s,
          "userName" => "testing Update",
          "email" => "update.complete@test.com",
        )
        expect(user_found_in_db.user_name).to eq "testing Update"
      end
    end
    #database cleaner active records: This is used to clean database.
    context "userDelete" do
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
        expect(data_dig("userDelete", "user", "id")).to eq dummy_user.id.to_s
        expect { User.find(dummy_user.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
