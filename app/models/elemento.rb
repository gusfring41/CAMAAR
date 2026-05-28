class Elemento < ApplicationRecord
  belongs_to :template
  has_many :campos, dependent: :destroy  
  validates :ordem, presence: true
  validates :ordem, uniqueness: { scope: :template_id }
end