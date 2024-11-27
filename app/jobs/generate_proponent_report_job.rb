# frozen_string_literal: true

class GenerateProponentReportJob < ApplicationJob
  include Rails.application.routes.url_helpers

  queue_as :default

  def perform(user_id)
    user = User.find(user_id)
    generate_pdf(user)
  end

  private

  def generate_pdf(user)
    data = user.inss_range_proponents_table_data

    image = user.report_image
    if image.attached?
      downloaded_image = image.download
      image_content_type = image.content_type
    else
      downloaded_image = nil
      image_content_type = nil
    end

    pdf = WickedPdf.new.pdf_from_string(
      ActionController::Base.new.render_to_string(
        template: "proponents/report",
        layout: "pdf",
        locals: { data: data, user: user, image: downloaded_image, image_content_type: image_content_type },
        handlers: [:erb],
        encoding: "UTF-8",
      ),
    )

    user.report_file.attach(
      io: StringIO.new(pdf),
      filename: "proponents_report_#{user.id}.pdf",
      content_type: "application/pdf",
    )

    Turbo::StreamsChannel.broadcast_update_to(
      "generate_report",
      target: "status_message",
      html: "<a class='btn btn-secondary' href='#{download_report_user_path(
        user_id: user.id,
        format: :pdf,
      )}'>Download do relatório</a> <span class='text-success'>Relatório gerado com sucesso</span>",
    )
  end
end
