class Property < ApplicationRecord
  belongs_to :user
  validates :description, length: { minimum: 50, message: "doit comporter au moins 50 caractères" }

  has_one_attached :photo
end
