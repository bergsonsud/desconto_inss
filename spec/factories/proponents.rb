# frozen_string_literal: true

FactoryBot.define do
  factory :proponent do
    name { Faker::Name.name }
    cpf { GenerateCpf.generate_cpf }
    birth_date { Faker::Date.birthday(min_age: 18, max_age: 65) }
    salary { Faker::Number.decimal(l_digits: 4, r_digits: 2) }
    discount { Faker::Number.decimal(l_digits: 4, r_digits: 2) }
    association :user
  end
end
