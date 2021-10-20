FactoryBot.define do
  factory :post do
    body { Faker::Lorem.characters(number: 50) }
    visit_date { Faker::Date.in_date_period }
  end
end
