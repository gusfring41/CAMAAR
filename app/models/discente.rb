class Discente < Usuario
  validates :curso_id, presence: true  
  has_and_belongs_to_many :turmas
end