FactoryBot.define do
  factory :user do
    username { Faker::Name.name }
    email { Faker::Internet.free_email }
    password { '1234abcd' }
    password_confirmation { password }
    name { '柿九毛子' }
    birthday { Faker::Date.backward }
  end
end
