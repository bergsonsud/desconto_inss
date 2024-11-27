# frozen_string_literal: true

require "rails_helper"

RSpec.describe(User, type: :model) do
  describe "#inss_range_proponents_table_data" do
    let(:user) { create(:user) }

    it "returns the correct number of proponents for a given range" do
      create(:proponent, user: user, salary: 1000)
      create_list(:proponent, 3, user: user, salary: 1500)
      create(:proponent, user: user, salary: 3400)

      result = user.inss_range_proponents_table_data
      expect(result).to(eq([
        ["R$ 0.0 - 1045.0", 1],
        ["R$ 1045.01 - 2089.6", 3],
        ["R$ 2089.61 - 3134.4", 0],
        ["R$ 3134.41 - 6101.06", 1],
      ]))
    end
  end
end
