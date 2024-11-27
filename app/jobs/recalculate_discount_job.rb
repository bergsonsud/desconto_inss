# frozen_string_literal: true

class RecalculateDiscountJob < ApplicationJob
  queue_as :default

  def perform(proponent_id)
    proponent = Proponent.find(proponent_id)
    proponent.update(discount: calculate_discount(proponent.salary))

    html = ApplicationController.render(
      partial: "proponents/proponent",
      locals: { proponent: proponent },
    )

    Turbo::StreamsChannel.broadcast_replace_to(
      "proponent_#{proponent.id}",
      target: "proponent_#{proponent.id}",
      html: html,
    )
  end

  private

  def calculate_discount(salary)
    InssCalculator::Calculate.new(salary).total
  end
end
