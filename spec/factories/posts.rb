FactoryBot.define do
  factory :post do
    image { Faker::Lorem.sentence }
    title { Faker::Lorem.sentence }
    text { Faker::Lorem.sentence }
    category_id { 4 }
    association :user

    after(:build) do |post|
      post.image.attach(io: File.open('app/assets/images/mainback.png'), filename: 'mainback.png')
    end
  end
end