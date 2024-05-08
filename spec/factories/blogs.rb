FactoryBot.define do
  factory :blog do
    title { Faker::Lorem.sentence(word_count: 4) }
    content { Faker::Lorem.paragraph(sentence_count: 5) }
    association :user
  end
end
