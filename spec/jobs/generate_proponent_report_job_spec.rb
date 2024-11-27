# frozen_string_literal: true

require "rails_helper"

RSpec.describe(GenerateProponentReportJob, type: :job) do
  let(:user) { create(:user) }
  let(:image) { Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/example.png"), "image/png") }
  let(:pdf_content) { "PDF content" }

  before do
    user.report_image.attach(image)
  end

  describe "#perform" do
    it "generates a report PDF and attaches it to the user" do
      allow_any_instance_of(WickedPdf).to(receive(:pdf_from_string).and_return(pdf_content))

      described_class.perform_now(user.id)

      expect(user.report_file).to(be_attached)
      expect(user.report_file.filename.to_s).to(eq("proponents_report_#{user.id}.pdf"))
      expect(user.report_file.content_type).to(eq("application/pdf"))
    end

    it "sends a Turbo Stream update with the success message" do
      allow_any_instance_of(WickedPdf).to(receive(:pdf_from_string).and_return(pdf_content))

      expect(Turbo::StreamsChannel).to(receive(:broadcast_update_to).with(
        "generate_report",
        target: "status_message",
        html: a_string_including("Download do relatório"),
      ))
      described_class.perform_now(user.id)
    end

    it "downloads the attached image and includes it in the PDF generation" do
      image_blob = user.report_image.blob
      allow(image_blob).to(receive(:download).and_return("image_data"))
      allow_any_instance_of(WickedPdf).to(receive(:pdf_from_string).and_return(pdf_content))

      described_class.perform_now(user.id)

      expect(user.report_file).to(be_attached)
    end

    it "does not attempt to download an image if none is attached" do
      user.report_image.purge

      image_blob = user.report_image.blob
      allow(image_blob).to(receive(:download).and_return("image_data"))
      allow_any_instance_of(WickedPdf).to(receive(:pdf_from_string).and_return(pdf_content))

      described_class.perform_now(user.id)

      expect(image_blob).not_to(have_received(:download))
    end
  end
end
