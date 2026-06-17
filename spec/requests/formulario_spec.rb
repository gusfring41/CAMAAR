require 'rails_helper'

RSpec.describe "Formularios", type: :request do
  let(:departamento) { Departamento.find_or_create_by!(nome: "Ciência da Computação", codigo: "CIC") }
  let(:disciplina) { Disciplina.find_or_create_by!(nome: "Engenharia de Software", codigo: "CIC0097", departamento: departamento) }
  let(:turma) { Turma.find_or_create_by!(numero_da_turma: "TA", disciplina: disciplina, semestre: "2026.1") }

  let(:curso) { Curso.find_or_create_by!(nome: "Ciência da Computação", codigo: "CIC", departamento: departamento) }

  let(:admin) do
    Administrador.create!(
      nome: "Admin", matricula: "123", email: "admin@unb.br",
      senha: "Senha123", senha_confirmation: "Senha123", departamento: departamento
    )
  end

  let(:discente) do
    Discente.create!(
      nome: "Aluno Teste", matricula: "241000", email: "aluno@unb.br",
      curso: curso, # 2. Recebendo a variável em vez da string!
      senha: "Senha123", senha_confirmation: "Senha123"
    )
  end

  describe "Feature 10: Criar formulário (Admin)" do
    before { post login_path, params: { login: admin.email, senha: "Senha123" } }

    it "cria um formulário vinculando à turma" do
      expect {
        post formularios_path, params: {
          formulario: {
            turma_id: turma.id
          }
        }
      }.to change(Formulario, :count).by(1)

      expect(response).to be_redirect
    end
  end

  describe "Feature 11: Visualizar formulários (Participante)" do
    let!(:formulario) do
      Formulario.create!(turma: turma)
    end

    before do
      post login_path, params: { login: discente.email, senha: "Senha123" }
    end

    it "lista os formulários disponíveis para o aluno" do
      get formularios_path
      expect(response).to have_http_status(:ok)
    end
  end
end
