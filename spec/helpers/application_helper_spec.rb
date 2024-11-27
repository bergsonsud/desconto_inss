# frozen_string_literal: true

# spec/helpers/application_helper_spec.rb
require "rails_helper"

RSpec.describe(ApplicationHelper, type: :helper) do
  describe "#render_turbo_stream_flash_messages" do
    it "renders turbo stream flash messages" do
      flash[:notice] = "Test Flash Message"

      render inline: "<%= render_turbo_stream_flash_messages %>"

      expect(rendered).to(include("turbo-stream"))
      expect(rendered).to(include("Test Flash Message"))
    end
  end

  describe "#form_error_notification" do
    let(:proponent) { build(:proponent, name: nil) }

    context "when there are errors" do
      it "displays the error messages" do
        proponent.valid?

        result = form_error_notification(proponent)

        expect(result).to(include("Nome não pode ficar em branco"))
      end
    end

    context "when there are no errors" do
      it "returns nil" do
        proponent.name = "Valid Name"
        result = form_error_notification(proponent)

        expect(result).to(be_nil)
      end
    end
  end

  describe "#format_real_br" do
    it "formats a value as Brazilian currency" do
      value = 1234.56
      result = helper.format_real_br(value)

      expect(result).to(eq("R$ 1.234,56"))
    end
  end
end
