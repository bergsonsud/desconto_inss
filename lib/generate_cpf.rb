# frozen_string_literal: true

class GenerateCpf
  def self.generate_cpf
    numbers = Array.new(9) { rand(0..9) }
    numbers << calculate_digit(numbers)
    numbers << calculate_digit(numbers)
    formatted_cpf = format_cpf(numbers.join)
    formatted_cpf
  end

  def self.calculate_digit(numbers)
    weight = numbers.length + 1
    sum = numbers.each_with_index.sum { |num, idx| num * (weight - idx) }
    digit = 11 - (sum % 11)
    digit > 9 ? 0 : digit
  end

  def self.format_cpf(cpf)
    cpf.insert(3, ".").insert(7, ".").insert(11, "-")
  end
end
