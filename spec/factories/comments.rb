FactoryBot.define do
  factory :comment do
    message { Faker::Lorem.paragraph(sentence_count: 5) }
    association :blog
    association :user
  end
end
