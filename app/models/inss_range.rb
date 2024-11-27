# frozen_string_literal: true

class InssRange < ApplicationRecord
  validates :lower_limit, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :rate, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1 }
end
