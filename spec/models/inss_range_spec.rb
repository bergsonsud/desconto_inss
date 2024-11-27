# frozen_string_literal: true

require "rails_helper"

RSpec.describe(InssRange, type: :model) do
  it { is_expected.to(validate_presence_of(:lower_limit)) }
  it { is_expected.to(validate_numericality_of(:lower_limit).is_greater_than_or_equal_to(0)) }
  it { is_expected.to(validate_presence_of(:rate)) }
  it { is_expected.to(validate_numericality_of(:rate).is_greater_than_or_equal_to(0).is_less_than_or_equal_to(1)) }
end
