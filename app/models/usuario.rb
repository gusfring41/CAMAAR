class Usuario < ApplicationRecord
  belongs_to :curso, optional: true
  belongs_to :departamento, optional: true
  validates :matricula, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :nome, presence: true
end