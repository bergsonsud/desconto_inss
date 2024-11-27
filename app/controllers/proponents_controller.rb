# frozen_string_literal: true

class ProponentsController < ApplicationController
  before_action :set_proponent, only: [:show, :edit, :update, :destroy, :edit_salary]

  def index
    @proponents = Proponent.page(params[:page]).per(5).order(id: :desc)
    @proponents_data = current_user.inss_range_proponents_table_data

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def show
  end

  def new
    @proponent = Proponent.new
    @proponent.user = current_user
    @proponent.build_address
  end

  def edit
  end

  def create
    @proponent = Proponent.new(proponent_params)

    respond_to do |format|
      if @proponent.save
        format.html { redirect_to(@proponent, notice: "Proponent was successfully created.") }
        format.json { render(:show, status: :created, location: @proponent) }
        format.turbo_stream { flash.now[:notice] = "Criado com sucesso!" }
      else
        format.html { render(:new, status: :unprocessable_entity) }
        format.json { render(json: @proponent.errors, status: :unprocessable_entity) }
      end
    end
  end

  def update
    respond_to do |format|
      if @proponent.update(proponent_params)
        format.html { redirect_to(@proponent, notice: "Proponent was successfully updated.") }
        format.json { render(:show, status: :ok, location: @proponent) }
        format.turbo_stream { flash.now[:notice] = "Atualizado com sucesso" }
        RecalculateDiscountJob.perform_later(@proponent.id)
      else
        format.html { render(:edit, status: :unprocessable_entity) }
        format.json { render(json: @proponent.errors, status: :unprocessable_entity) }
      end
    end
  end

  def destroy
    @proponent.destroy!

    respond_to do |format|
      format.html { redirect_to(proponents_path, status: :see_other, notice: "Proponent was successfully destroyed.") }
      format.json { head(:no_content) }

      format.turbo_stream do
        flash.now[:notice] = "Removido com sucesso!"
        render(turbo_stream: [
          turbo_stream.remove(@proponent),
          turbo_stream.update("flash", partial: "layouts/flash"),
        ])
      end
    end
  end

  def calculate_discount
    salary = params[:salary].delete(".").tr(",", ".").to_f
    calculator = InssCalculator::Calculate.new(salary)
    render(json: { discount: calculator.total })
  end

  def report_show
  end

  def generate_report
    @user = current_user
    @image_url = url_for(@user.report_image) if @user.report_image.attached?

    GenerateProponentReportJob.set(wait: 5.seconds).perform_later(@user.id)
    respond_to do |format|
      format.turbo_stream do
        render(turbo_stream: turbo_stream.update("status_message", ""))
      end

      format.json { render(json: { message: "Relatório sendo gerado... Aguarde!" }, status: :ok) }
      format.html { redirect_to(proponents_path, notice: "Relatório gerado com sucesso!") }
    end
  end

  def save_report_image
    unless current_user
      render(json: { error: "Usuário não autenticado" }, status: :unauthorized)
      return
    end

    image_file = params[:image]

    if image_file.nil?
      render(json: { error: "Imagem não recebida." }, status: :unprocessable_entity)
      return
    end
    current_user.report_image.attach(io: image_file, filename: "report_image.png", content_type: "image/png")

    render(json: { message: "Imagem gerada e salva com sucesso!" }, status: :ok)
  rescue => e
    render(json: { error: "Erro ao processar a imagem: #{e.message}" }, status: :unprocessable_entity)
  end

  def edit_salary
  end

  private

  def set_proponent
    @proponent = Proponent.find(params[:id])
  end

  def proponent_params
    params.require(:proponent).permit(
      :name,
      :cpf,
      :birth_date,
      :salary,
      :discount,
      :personal_phone,
      :reference_phone,
      :user_id,
      address_attributes: [:id, :street, :number, :neighborhood, :city, :state, :zip_code],
    )
  end
end
