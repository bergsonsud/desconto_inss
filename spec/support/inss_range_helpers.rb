# frozen_string_literal: true

module InssRangeHelpers
  def create_ranges
    InssRange.create!(lower_limit: 0, upper_limit: 1_045.00, rate: 0.075)
    InssRange.create!(lower_limit: 1_045.01, upper_limit: 2_089.60, rate: 0.09)
    InssRange.create!(lower_limit: 2_089.61, upper_limit: 3_134.40, rate: 0.12)
    InssRange.create!(lower_limit: 3_134.41, upper_limit: 6_101.06, rate: 0.14)
  end
end

RSpec.configure do |config|
  config.include(InssRangeHelpers, type: :model)
  config.include(InssRangeHelpers, type: :service)
end
