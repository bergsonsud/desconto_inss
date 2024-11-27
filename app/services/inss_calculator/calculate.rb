# frozen_string_literal: true

module InssCalculator
  class Calculate
    def initialize(salary)
      @salary = salary
      @calculators = Factory.build(salary)
    end

    def total
      @calculators.sum(&:calculate)
    end
  end
end
