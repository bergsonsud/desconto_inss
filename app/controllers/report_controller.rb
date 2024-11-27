# frozen_string_literal: true

class ReportController < ApplicationController
  def download
    user = User.find(params[:user_id])
    file = user.report_file.download
    send_data(file, type: "application/pdf", disposition: "attachment")
  end
end
