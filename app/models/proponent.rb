# frozen_string_literal: true

class Proponent < ApplicationRecord
  belongs_to :user
  has_one :address, dependent: :destroy

  validates :name, uniqueness: { scope: :cpf }
  validates :cpf, uniqueness: true
  validates :name, :cpf, :salary, presence: true
  validates :cpf, cpf: true
  validates :salary, numericality: { greater_than_or_equal_to: 1 }, allow_nil: false

  accepts_nested_attributes_for :address, allow_destroy: true
end
