User.create!(email: "admin@gmail.com", password: "123456", password_confirmation: "123456")
User.create!(email: Faker::Internet.email, password: "123456", password_confirmation: "123456")

InssRange.create!(lower_limit: 0, upper_limit: 1_045.00, rate: 0.075)
InssRange.create!(lower_limit: 1_045.01, upper_limit: 2_089.60, rate: 0.09)
InssRange.create!(lower_limit: 2_089.61, upper_limit: 3_134.40, rate: 0.12)
InssRange.create!(lower_limit: 3_134.41, upper_limit: 6_101.06, rate: 0.14)

def generate_proponent(user)
  salary = Faker::Number.decimal(l_digits: 4, r_digits: 2)
  discount = InssCalculator::Calculate.new(salary).total
  proponent = Proponent.create!(
    name: Faker::Name.name,
    cpf: GenerateCpf.generate_cpf,
    birth_date: Faker::Date.birthday(min_age: 18, max_age: 65),
    salary: salary,
    discount: discount,
    personal_phone: Faker::PhoneNumber.cell_phone,
    reference_phone: Faker::PhoneNumber.cell_phone,
    user: user,
  )

  proponent.create_address!(
    street: Faker::Address.street_name,
    number: Faker::Address.building_number,
    neighborhood: Faker::Address.community,
    city: Faker::Address.city,
    state: Faker::Address.state_abbr,
    zip_code: Faker::Address.zip_code,
  )
end

10.times { generate_proponent(User.first) }
10.times { generate_proponent(User.last) }
