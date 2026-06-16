# Departamentos
dept_cic = Departamento.find_or_create_by!(codigo: "CIC") do |d|
  d.nome = "Ciência da Computação"
end

dept_mat = Departamento.find_or_create_by!(codigo: "MAT") do |d|
  d.nome = "Matemática"
end

# Cursos
curso_cc = Curso.find_or_create_by!(codigo: "CC") do |c|
  c.nome = "Bacharelado em Ciência da Computação"
  c.departamento = dept_cic
end

# Disciplinas
disc_ed = Disciplina.find_or_create_by!(codigo: "CIC0001") do |d|
  d.nome = "Estrutura de Dados"
  d.departamento = dept_cic
end

# Turmas
turma_a = Turma.find_or_create_by!(numero_da_turma: "A", semestre: "2026.1", disciplina: disc_ed) do |t|
  t.horario = "35T23"
end

# Usuários
docente = Docente.find_or_initialize_by(email: "docente@teste.com")
docente.update!(
  nome: "Docente Teste",
  matricula: "241000001",
  senha: "teste123",
  senha_confirmation: "teste123",
  departamento: dept_cic,
  formacao: "doutorado"
) unless docente.persisted?

discente = Discente.find_or_initialize_by(email: "discente@teste.com")
discente.update!(
  nome: "Discente Teste",
  matricula: "241000002",
  senha: "teste123",
  senha_confirmation: "teste123",
  curso: curso_cc,
  formacao: "graduacao"
) unless discente.persisted?

admin = Administrador.find_or_initialize_by(email: "admin@teste.com")
admin.update!(
  nome: "Admin Teste",
  matricula: "240000003",
  senha: "teste123",
  senha_confirmation: "teste123",
  departamento: dept_cic
) unless admin.persisted?

# Vinculando Usuários às Turmas
discente.turmas << turma_a unless discente.turmas.include?(turma_a)
docente.turmas << turma_a unless docente.turmas.include?(turma_a)

puts "Seeds finalizados com sucesso!"
puts "Usuários criados:"
puts "  discente@teste.com / teste123 (Discente)"
puts "  docente@teste.com / teste123 (Docente)"
puts "  admin@teste.com / teste123 (Admin)"
