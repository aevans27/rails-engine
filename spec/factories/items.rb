FactoryBot.define do
  factory :item do
    name { Faker::Company.name }
    description { Faker::Lorem.paragraph }
    unit_price { Faker::Number.decimal(l_digits: 2) }
    merchant_id { Faker::Number.number }
  end
end
