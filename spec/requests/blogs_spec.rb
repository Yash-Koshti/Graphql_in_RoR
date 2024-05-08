require "rails_helper"
require "graphql_helper"

RSpec.describe "Blogs", type: :request do
  let(:context) { {} }
  let(:variables) { {} }
  let(:result) { execute_graphql_test }

  describe "query" do
    context "blogs" do
      let(:query_string) do
        <<~GQL
          query{
            blogs {
              id
              title
              content
              user {
                id
                userName
                email
              }
            }
          }
        GQL
      end

      it "should return all blogs" do
        FactoryBot.create(:blog)

        # pp "---Query---"
        # pp "Error message: #{result["errors"][0]["message"]}" unless result["data"]
        # pp "Data_dig: #{data_dig}"

        expect(data_dig("blogs")).not_to be_nil
      end
    end
  end

  describe "mutation" do
    context "blogCreate" do
      let(:dummy_user) { FactoryBot.create(:user) }
      let(:dummy_blog) { FactoryBot.attributes_for(:blog) }
      let(:query_string) do
        <<~GQL
          mutation {
            blogCreate(input: {
              blogInput: {
                title: "#{dummy_blog[:title]}",
                content: "#{dummy_blog[:content]}",
                userId: #{dummy_user.id}
              }
            }) {
              blog {
                id
                title
                content
                user {
                  id
                  userName
                  email
                }
              }
            }
          }
        GQL
      end

      it "should create a user and return it" do
        blog_returned_from_query = data_dig("blogCreate", "blog")

        # pp "---Create---"
        # pp "Error message: #{result["errors"][0]["message"]}" unless result["data"]
        # pp "Data_dig: #{data_dig}"

        expect(blog_returned_from_query).to include(
          "title" => dummy_blog[:title].to_s,
          "content" => dummy_blog[:content],
          "user" => {
            "id" => dummy_user.id.to_s,
            "userName" => dummy_user.user_name,
            "email" => dummy_user.email,
          },
        )
      end
    end

    context "blogUpdate" do
      let(:dummy_user) { FactoryBot.create(:user) }
      let(:dummy_blog) { FactoryBot.create(:blog) }
      let(:query_string) do
        <<~GQL
          mutation {
            blogUpdate(input: {
              id: #{dummy_blog.id},
              blogInput: {
                title: "Testing blog title",
                content: "This is a testing content!",
                userId: #{dummy_user.id}
              }
            }) {
              blog {
                id
                title
                content
                user {
                  id
                  userName
                  email
                }
              }
            }
          }
        GQL
      end

      it "should update the existing blog" do
        blog_returned_from_query = data_dig("blogUpdate", "blog")
        blog_found_in_db = Blog.find(dummy_blog.id)

        # pp "---Update---"
        # pp "Error message: #{result["errors"][0]["message"]}" unless result["data"]
        # pp "Data_dig: #{data_dig}"

        expect(blog_returned_from_query).to include(
          "id" => dummy_blog.id.to_s,
          "title" => "Testing blog title",
          "content" => "This is a testing content!",
          "user" => {
            "id" => dummy_user.id.to_s,
            "userName" => dummy_user.user_name,
            "email" => dummy_user.email,
          },
        )
        expect(blog_found_in_db.title).to eq "Testing blog title"
        expect(blog_found_in_db.content).to eq "This is a testing content!"
      end
    end

    context "blogDelete" do
      let(:dummy_blog) { FactoryBot.create(:blog) }
      let(:query_string) do
        <<~GQL
          mutation {
            blogDelete(input: {
              id: #{dummy_blog.id}
            }) {
              blog {
                id
              }
            }
          }
        GQL
      end

      it "should delete existing blog" do
        expect(data_dig("blogDelete", "blog", "id")).to eq dummy_blog.id.to_s
        expect { Blog.find(dummy_blog.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
