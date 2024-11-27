# frozen_string_literal: true

class InssRangeProponent < ApplicationRecord
  self.table_name = "inss_range_proponent"
  self.primary_key = "id"

  belongs_to :user

  scope :by_user_id, ->(user_id) {
    where(user_id: user_id)
  }
end
