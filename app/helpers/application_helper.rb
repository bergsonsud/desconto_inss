# frozen_string_literal: true

module ApplicationHelper
  def render_turbo_stream_flash_messages
    turbo_stream.prepend("flash", partial: "layouts/flash")
  end

  def form_error_notification(object)
    return if object.errors.none?

    tag.div(class: "error-message") do
      object.errors.full_messages.to_sentence.capitalize
    end
  end

  def format_real_br(value)
    number_to_currency(value, unit: "R$ ", separator: ",", delimiter: ".")
  end
end
