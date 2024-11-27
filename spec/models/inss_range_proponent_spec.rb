# frozen_string_literal: true

require "rails_helper"

RSpec.describe(InssRangeProponent, type: :model) do
  before(:all) do
    create_ranges
  end

  describe "scopes" do
    it "retorna o número correto de proponentes para um determinado intervalo" do
      user = create(:user)
      create_list(:proponent, 20, user: user, salary: 1500)

      result = described_class.by_user_id(user.id)
      expect(result.size).to(eq(4))
    end
  end
end
