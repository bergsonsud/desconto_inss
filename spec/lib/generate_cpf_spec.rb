# frozen_string_literal: true

# spec/lib/generate_cpf_spec.rb

require "rails_helper"

RSpec.describe(GenerateCpf, type: :lib) do
  describe ".generate_cpf" do
    it "gera um CPF com 11 caracteres" do
      cpf = described_class.generate_cpf
      expect(cpf.length).to(eq(14))
    end

    it "gera um CPF no formato correto xxx.xxx.xxx-xx" do
      cpf = described_class.generate_cpf
      expect(cpf).to(match(/^\d{3}\.\d{3}\.\d{3}-\d{2}$/))
    end

    it "gera um CPF válido" do
      cpf = described_class.generate_cpf
      cpf_without_format = cpf.delete(".").delete("-")
      digits = cpf_without_format.chars.map(&:to_i)

      expect(valid_cpf?(digits)).to(be(true))
    end
  end

  def valid_cpf?(cpf)
    return false if cpf.length != 11

    first_digit = calculate_digit(cpf[0..8])
    second_digit = calculate_digit(cpf[0..9])

    cpf[9] == first_digit && cpf[10] == second_digit
  end

  def calculate_digit(numbers)
    weight = numbers.length + 1
    sum = numbers.each_with_index.sum { |num, idx| num * (weight - idx) }
    digit = 11 - (sum % 11)
    digit > 9 ? 0 : digit
  end
end
