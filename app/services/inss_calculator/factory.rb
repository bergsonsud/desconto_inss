# frozen_string_literal: true

module InssCalculator
  class Factory
    def self.build(salary)
      ranges = InssRange.all.order(:lower_limit)
      ranges.map { |range| RangeCalculation.new(salary, range) }
    end
  end
end
