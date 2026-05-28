class Template < ApplicationRecord
  has_many :elementos, dependent: :destroy
  validates :nome, presence: true
end