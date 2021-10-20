FactoryBot.define do
  factory :shrine do
    name { Faker::Lorem.characters(number: 8) }
    address { Faker::Lorem.characters(number: 30) }
    introduction { Faker::Lorem.characters(number: 50) }
  end
end
