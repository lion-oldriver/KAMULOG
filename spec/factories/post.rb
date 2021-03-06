FactoryBot.define do
  factory :post do
    body { Faker::Lorem.characters(number: 50) }
    visit_date { Faker::Date.backward(days: 1) }
  end
end
