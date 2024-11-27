# frozen_string_literal: true

require "rails_helper"

module InssCalculator
  RSpec.describe(Calculate, type: :service) do
    let(:salary) { 5000 }
    let(:range1) { double("InssRange", lower_limit: 0, upper_limit: 1000, rate: 0.1) }
    let(:range2) { double("InssRange", lower_limit: 1000, upper_limit: 5000, rate: 0.2) }
    let(:range3) { double("InssRange", lower_limit: 5000, upper_limit: 10000, rate: 0.3) }

    let(:range_calculation1) { double("RangeCalculation", calculate: 100) }
    let(:range_calculation2) { double("RangeCalculation", calculate: 200) }
    let(:range_calculation3) { double("RangeCalculation", calculate: 300) }

    before do
      allow(InssCalculator::Factory).to(receive(:build).and_return([
        range_calculation1,
        range_calculation2,
        range_calculation3,
      ]))
    end

    it "returns the total sum of all range calculations" do
      calculator = described_class.new(salary)
      expect(calculator.total).to(eq(600))
    end
  end
end
