# frozen_string_literal: true

require "rails_helper"

module InssCalculator
  RSpec.describe(Factory, type: :service) do
    let(:salary) { 5000 }

    before(:all) do
      InssRange.delete_all
      InssRange.create!(lower_limit: 0, upper_limit: 1000, rate: 0.1)
      InssRange.create!(lower_limit: 1000, upper_limit: 5000, rate: 0.2)
      InssRange.create!(lower_limit: 5000, upper_limit: 10000, rate: 0.3)
    end

    after(:all) do
      InssRange.delete_all
    end

    it "builds RangeCalculation instances for each range" do
      result = described_class.build(salary)

      expect(result.length).to(eq(3))
      expect(result.first).to(be_an_instance_of(RangeCalculation))
    end
  end
end
