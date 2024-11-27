# frozen_string_literal: true

FactoryBot.define do
  factory :image_blob, class: "ActiveStorage::Blob" do
    io { File.open(Rails.root.join("spec/fixtures/example.png")) }
    filename { "example.png" }
    content_type { "image/png" }
  end
end
