# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
    :registerable,
    :recoverable,
    :rememberable,
    :validatable
  has_one_attached :report_file
  has_one_attached :report_image

  def inss_range_proponents_table_data
    @inss_range_proponents_table_data ||= InssRangeProponent.by_user_id(id).map do |range|
      [
        "R$ #{range.range_lower_limit} - #{range.range_upper_limit}",
        range.proponent_count,
      ]
    end
  end
end
