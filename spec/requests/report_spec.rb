# frozen_string_literal: true

require "rails_helper"

RSpec.describe("ReportDownloads", type: :request) do
  let(:user) { create(:user) } # Criação do usuário
  let(:file) { Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/dummy.pdf"), "application/pdf") }

  before do
    user.report_file.attach(file)
    sign_in user
  end

  describe "GET /download" do
    it "downloads the user's report file" do
      get download_report_user_path(user_id: user.id)

      expect(response).to(have_http_status(:success))

      expect(response.content_type).to(eq("application/pdf"))

      expect(response.headers["Content-Disposition"]).to(include("attachment"))
    end
  end
end
