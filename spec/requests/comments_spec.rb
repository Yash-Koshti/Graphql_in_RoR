require "rails_helper"
require "graphql_helper"

RSpec.describe "Comments", type: :request do
  let(:context) { {} }
  let(:variables) { {} }
  let(:result) { execute_graphql_test }

  describe "query" do
    context "comments" do
      let(:query_string) do
        <<~GQL
          query {
            comments {
              id
              message
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
              user {
                id
                userName
                email
              }
            }
          }
        GQL
      end

      it "should return all comments" do
        FactoryBot.create(:comment)
        # pp "#{data_dig}"

        expect(data_dig("comments")).not_to be_nil
      end
    end
  end

  describe "mutation" do
    context "commentCreate" do
      let(:dummy_user) { FactoryBot.create(:user) }
      let(:dummy_blog) { FactoryBot.create(:blog) }
      let(:dummy_comment) { FactoryBot.attributes_for(:comment) }
      let(:query_string) do
        <<~GQL
          mutation {
            commentCreate(input: {
              commentInput: {
                message: "#{dummy_comment[:message]}",
                blogId: #{dummy_blog.id},
                userId: #{dummy_user.id}
              }
            }) {
              comment {
                id
                message
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

      it "should create new comment" do
        comment_returned_from_query = data_dig("commentCreate", "comment")

        expect(Comment.find(comment_returned_from_query["id"])).not_to be_nil
        expect(comment_returned_from_query).to include(
          "message" => dummy_comment[:message],
          "blog" => {
            "id" => dummy_blog.id.to_s,
            "title" => dummy_blog.title,
            "content" => dummy_blog.content,
            "user" => {
              "id" => dummy_blog.user.id.to_s,
              "userName" => dummy_blog.user.user_name,
              "email" => dummy_blog.user.email,
            },
          },
          "user" => {
            "id" => dummy_user.id.to_s,
            "userName" => dummy_user.user_name,
            "email" => dummy_user.email,
          },
        )
      end
    end

    context "commentUpdate" do
      let(:dummy_comment) { FactoryBot.create(:comment) }
      let(:dummy_user) { FactoryBot.create(:user) }
      let(:dummy_blog) { FactoryBot.create(:blog) }
      let(:query_string) do
        <<~GQL
          mutation {
            commentUpdate(input: {
              id: #{dummy_comment[:id]},
              commentInput: {
                message: "Commenting here for testing",
                blogId: #{dummy_blog[:id]},
                userId: #{dummy_user[:id]}
              }
            }) {
              comment {
                id
                message
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

      it "should update the comment" do
        comment_returned_from_query = data_dig("commentUpdate", "comment")
        comment_found_in_db = Comment.find(dummy_comment.id)

        expect(comment_returned_from_query).to include(
          "message" => "Commenting here for testing",
          "blog" => {
            "id" => dummy_blog.id.to_s,
            "title" => dummy_blog.title,
            "content" => dummy_blog.content,
            "user" => {
              "id" => dummy_blog.user.id.to_s,
              "userName" => dummy_blog.user.user_name,
              "email" => dummy_blog.user.email,
            },
          },
          "user" => {
            "id" => dummy_user.id.to_s,
            "userName" => dummy_user.user_name,
            "email" => dummy_user.email,
          },
        )
        expect(comment_found_in_db.message).to eq "Commenting here for testing"
        expect(comment_found_in_db.blog.id).to eq dummy_blog.id
        expect(comment_found_in_db.user.id).to eq dummy_user.id
      end
    end

    context "commentDelete" do
      let(:dummy_comment) { FactoryBot.create(:comment) }
      let(:query_string) do
        <<~GQL
          mutation {
            commentDelete(input: {
              id: #{dummy_comment.id}
            }) {
              comment {
                id
              }
            }
          }
        GQL
      end

      it "should delete the comment" do
        expect(data_dig("commentDelete", "comment", "id")).to eq dummy_comment.id.to_s
        expect { Comment.find(dummy_comment.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
