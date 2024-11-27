# frozen_string_literal: true

require "rails_helper"

RSpec.describe(RecalculateDiscountJob, type: :job) do
  let(:proponent) { create(:proponent, salary: 5000.0) }
  let(:discount) { InssCalculator::Calculate.new(proponent.salary).total }

  describe "#perform" do
    it "calculates the discount and updates the proponent's discount" do
      described_class.perform_now(proponent.id)

      proponent.reload
      expect(proponent.discount).to(eq(discount))
    end

    it "broadcasts the update to the Turbo Stream" do
      expect(Turbo::StreamsChannel).to(receive(:broadcast_replace_to).with(
        "proponent_#{proponent.id}",
        target: "proponent_#{proponent.id}",
        html: a_string_matching(%r{<turbo-frame id="proponent_#{proponent.id}">.*</turbo-frame>}m),
      ))

      # Chama o job
      described_class.perform_now(proponent.id)
    end
  end
end
