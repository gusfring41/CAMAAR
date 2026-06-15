class Administrador < Usuario
  validates :departamento_id, presence: true
end
