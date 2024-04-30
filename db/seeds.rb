# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

user_1 = User.create!(
    user_name: "JohnDoe",
    email: "johnDoe@gmail.com"
)

user_2 = User.create!(
    user_name: "StarLord",
    email: "starLordTheGuardian@galaxy.com"
)

user_3 = User.create!(
    user_name: "Groot",
    email: "iAmGroot@galaxy.com"
)
    
blog_1 = Blog.create!(
    title: "How to design a HomePage",
    content: "Lorem ipsum dolor sit amet consectetur adipisicing elit. Porro quam, ea velit atque modi quasi odio exercitationem ducimus! Excepturi, iure. Officia amet nemo minima, quo temporibus nisi iste dolorum aliquid laudantium accusamus ratione. Corporis!",
    user: user_1
)

blog_2 = Blog.create!(
    title: "I found the space stone",
    content: "Lorem ipsum dolor sit amet consectetur adipisicing elit. Porro quam, ea velit atque modi quasi odio exercitationem ducimus! Excepturi, iure. Officia amet nemo minima, quo temporibus nisi iste dolorum aliquid laudantium accusamus ratione. Corporis!",
    user: user_2
)

Comment.create!(
    [
        {
            message: "I loved the Garden design",
            blog: blog_1,
            user: user_3
        },
        {
            message: "I don't need a website I'm already popular!",
            blog: blog_1,
            user: user_2
        },
        {
            message: "Oh I read this online",
            blog: blog_2,
            user: user_1
        },
        {
            message: "Liar. You were defeated by the avengers who took it with them.",
            blog: blog_2,
            user: user_3
        }
    ]
)
