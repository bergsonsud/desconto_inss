# frozen_string_literal: true

module InssCalculator
  class RangeCalculation < BaseCalculation
    def calculate
      return 0 if @salary < @range.lower_limit

      applicable_amount = [
        @salary - @range.lower_limit,
        @range.upper_limit ? @range.upper_limit - @range.lower_limit : Float::INFINITY,
      ].min

      (applicable_amount * @range.rate).floor(2)
    end
  end
end
