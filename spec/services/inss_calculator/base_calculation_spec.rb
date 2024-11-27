# frozen_string_literal: true

require "rails_helper"

module InssCalculator
  RSpec.describe(BaseCalculation, type: :service) do
    let(:salary) { 5000 }
    let(:range) { double("InssRange", lower_limit: 0, upper_limit: 10000, rate: 0.08) }

    it "raises NotImplementedError when calculate is called" do
      calculation = described_class.new(salary, range)
      expect { calculation.calculate }.to(raise_error(NotImplementedError, "Implement this method in a subclass"))
    end
  end
end
