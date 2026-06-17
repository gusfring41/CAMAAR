class Formulario < ApplicationRecord
  belongs_to :turma, optional: true
  has_many :elemento_forms, dependent: :destroy
  has_many :resposta_forms, dependent: :destroy
end
