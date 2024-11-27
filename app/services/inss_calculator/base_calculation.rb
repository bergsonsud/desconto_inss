# frozen_string_literal: true

module InssCalculator
  class BaseCalculation
    def initialize(salary, range)
      @salary = salary
      @range = range
    end

    def calculate
      raise NotImplementedError, "Implement this method in a subclass"
    end
  end
end
