# frozen_string_literal: true

require "rails_helper"

module InssCalculator
  RSpec.describe(RangeCalculation, type: :service) do
    let(:range) { double("InssRange", lower_limit: 1000, upper_limit: 5000, rate: 0.2) }

    context "when salary is within the range" do
      let(:salary) { 3000 }
      let(:calculation) { described_class.new(salary, range) }

      it "calculates the correct INSS" do
        expect(calculation.calculate).to(eq(400.0)) # (3000 - 1000) * 0.2
      end
    end

    context "when salary is below the range" do
      let(:salary) { 500 }
      let(:calculation) { described_class.new(salary, range) }

      it "returns 0" do
        expect(calculation.calculate).to(eq(0))
      end
    end

    context "when salary is above the range" do
      let(:salary) { 6000 }
      let(:calculation) { described_class.new(salary, range) }

      it "calculates the correct INSS with the upper limit" do
        expect(calculation.calculate).to(eq(800.0))
      end
    end
  end
end
