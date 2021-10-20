FactoryBot.define do
  factory :user do
    name { Faker::Lorem.characters(number: 10) }
    introduction { Faker::Lorem.characters(number: 30) }
    email { Faker::Internet.email }
    password { Faker::Lorem.characters(number: 6) }
    profile_image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'app/assets/images/no_image.jpg')) }
  end
end
