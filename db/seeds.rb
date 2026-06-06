# This file should ensure the existence of records required to run the application in every environment.
# The code here should be idempotent so that it can be executed at any point in every environment.

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

# Usuários (Docente, Discente, Admin)
# A migration AjustaNulosParaSti permite que curso e departamento sejam nulos,
# mas vamos associá-los aos nossos testes para dados mais ricos.

docente = Docente.find_or_initialize_by(email: "docente@teste.com")
docente.nome ||= "Docente Teste"
docente.matricula ||= "241000001"
docente.senha = "teste123"
docente.senha_confirmation = "teste123"
docente.departamento = dept_cic
docente.formacao = "doutorado"
docente.save!

discente = Discente.find_or_initialize_by(email: "discente@teste.com")
discente.nome ||= "Discente Teste"
discente.matricula ||= "241000002"
discente.senha = "teste123"
discente.senha_confirmation = "teste123"
discente.curso = curso_cc
docente.formacao = "graduacao"
discente.save!

admin = Administrador.find_or_initialize_by(email: "admin@teste.com")
admin.nome ||= "Admin Teste"
admin.matricula ||= "240000003"
admin.senha = "teste123"
admin.senha_confirmation = "teste123"
admin.departamento = dept_cic
admin.save!

# Vinculando Usuários às Turmas
discente.turmas << turma_a unless discente.turmas.include?(turma_a)
docente.turmas << turma_a unless docente.turmas.include?(turma_a)

# Templates, Elementos e Campos (Estrutura base de formulários)
template = Template.find_or_create_by!(nome: "Avaliação de Disciplina Padrão")

elemento1 = Elemento.find_or_create_by!(enunciado: "Avalie a didática do professor", template: template) do |e|
  e.ordem = 1
end

campo1 = Campo.find_or_create_by!(enunciado: "Nota de 1 a 5", elemento: elemento1) do |c|
  c.ordem = 1
  c.tipo_elemento = "escala"
end

# Formulários de Turma, Elementos de Form e Campos de Form
formulario = Formulario.find_or_create_by!(turma: turma_a)

elemento_form = ElementoForm.find_or_create_by!(enunciado: elemento1.enunciado, formulario: formulario) do |ef|
  ef.ordem = elemento1.ordem
end

campo_form = CampoForm.find_or_create_by!(enunciado: campo1.enunciado, elemento_form: elemento_form) do |cf|
  cf.ordem = campo1.ordem
end

# Respostas (Simulando uma resposta de um Discente)
resposta_form = RespostaForm.find_or_create_by!(formulario: formulario, usuario: discente) do |rf|
  rf.data_submissao = Date.today
end

RespostaElem.find_or_create_by!(resposta_form: resposta_form, elemento_form: elemento_form) do |re|
  re.texto_resposta = "5"
  re.campo_form = campo_form # campo_form_id pode ser nulo pela sua migration, mas passamos aqui
end

puts "Seeds finalizados com sucesso"