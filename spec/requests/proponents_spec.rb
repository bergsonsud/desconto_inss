# frozen_string_literal: true

require "rails_helper"

RSpec.describe("/proponents", type: :request) do
  let(:user) { create(:user) } # Você pode criar um usuário com `FactoryBot`
  let(:valid_attributes) do
    {
      name: "John Doe",
      cpf: GenerateCpf.generate_cpf,
      birth_date: "1990-01-01",
      salary: 5000,
      discount: 100,
      personal_phone: "11987654321",
      reference_phone: "11987654322",
      user_id: user.id,
    }
  end
  let(:invalid_attributes) do
    {
      name: nil,
      cpf: "12345678901",
      birth_date: "1990-01-01",
      salary: 5000,
      personal_phone: "11987654321",
      reference_phone: "11987654322",
      user_id: user.id,
    }
  end

  before do
    sign_in user
  end

  describe "GET /index" do
    it "renders a successful response" do
      Proponent.create!(valid_attributes)
      get proponents_url
      expect(response).to(be_successful)
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      proponent = Proponent.create!(valid_attributes)
      get proponent_url(proponent)
      expect(response).to(be_successful)
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_proponent_url
      expect(response).to(be_successful)
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      proponent = Proponent.create!(valid_attributes)
      get edit_proponent_url(proponent)
      expect(response).to(be_successful)
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Proponent and redirects to the show page" do
        expect do
          post(proponents_url, params: { proponent: valid_attributes })
        end.to(change(Proponent, :count).by(1))
        expect(response).to(redirect_to(proponent_url(Proponent.last)))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Proponent and renders the form again" do
        expect do
          post(proponents_url, params: { proponent: invalid_attributes })
        end.not_to(change(Proponent, :count))
        expect(response).to(render_template(:new))
      end
    end
  end

  describe "PATCH /update" do
    let(:proponent) { Proponent.create!(valid_attributes) }

    context "with valid parameters" do
      let(:new_attributes) { { name: "Updated Name" } }

      it "updates the requested proponent and redirects to the show page" do
        patch proponent_url(proponent), params: { proponent: new_attributes }
        proponent.reload
        expect(proponent.name).to(eq("Updated Name"))
        expect(response).to(redirect_to(proponent_url(proponent)))
      end
    end

    context "with invalid parameters" do
      it "does not update the proponent and re-renders the edit form" do
        patch proponent_url(proponent), params: { proponent: invalid_attributes }
        proponent.reload
        expect(proponent.name).not_to(be_nil)
        expect(response).to(render_template(:edit))
      end
    end
  end

  describe "DELETE /destroy" do
    let!(:proponent) { Proponent.create!(valid_attributes) }

    it "destroys the requested proponent" do
      expect do
        delete(proponent_url(proponent))
      end.to(change(Proponent, :count).by(-1))
      expect(response).to(redirect_to(proponents_url))
    end
  end

  describe "GET /calculate_discount" do
    it "calculates the discount and returns a success response" do
      get calculate_discount_proponents_url, params: { salary: 3000 }
      json_response = JSON.parse(response.body)
      expect(json_response["discount"]).to(eq("281.62"))
    end
  end

  describe "POST /save_report_image" do
    it "saves the report image and returns a success response" do
      image = fixture_file_upload("spec/fixtures/example.png", "image/png")
      post save_report_image_proponents_url, params: { image: image }
      json_response = JSON.parse(response.body)
      expect(json_response["message"]).to(eq("Imagem gerada e salva com sucesso!"))
    end

    it "returns an error response when image is not received" do
      post save_report_image_proponents_url
      json_response = JSON.parse(response.body)
      expect(json_response["error"]).to(eq("Imagem não recebida."))
    end
  end

  describe "POST /proponents/generate_report" do
    it "responde com turbo stream" do
      post generate_report_proponents_path(user_id: user.id), as: :turbo_stream

      # Verifica se a resposta turbo stream é bem-sucedida
      expect(response).to(have_http_status(:ok))
      expect(response.body).to(include("status_message"))
    end

    it "responde com json indicando que o relatório está sendo gerado" do
      post generate_report_proponents_path(user_id: user.id), as: :json

      # Verifica se a resposta json contém a mensagem esperada
      json_response = JSON.parse(response.body)
      expect(response).to(have_http_status(:ok))
      expect(json_response["message"]).to(eq("Relatório sendo gerado... Aguarde!"))
    end

    it "redireciona para a página de proponents com uma mensagem de sucesso" do
      post generate_report_proponents_path(user_id: user.id)

      # Verifica se o redirecionamento ocorre e a mensagem é exibida
      expect(response).to(redirect_to(proponents_path))
      follow_redirect!

      expect(response.body).to(include("Relatório gerado com sucesso!"))
    end
  end
end
