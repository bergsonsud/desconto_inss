# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Proponent, type: :model) do
  it { is_expected.to(belong_to(:user)) }
  it { is_expected.to(have_one(:address).dependent(:destroy)) }
  it { is_expected.to(validate_presence_of(:name)) }
  it { is_expected.to(validate_presence_of(:cpf)) }
end
