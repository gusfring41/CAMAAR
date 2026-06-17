require 'rails_helper'

RSpec.describe "Gerenciamento de Senhas", type: :request do
  let(:departamento) { Departamento.find_or_create_by!(nome: "Ciência da Computação", codigo: "CIC") }
  let(:usuario_sem_senha) do
    Docente.create!(
      nome: "Novo Professor",
      matricula: "doc002",
      email: "novo@unb.br",
      formacao: "Mestrado",
      senha_hash: nil,
      definicao_senha_token: "token_definicao_123"
    )
  end

  let(:usuario_esquecido) do
    Docente.create!(
      nome: "Professor Esquecido",
      matricula: "doc003",
      email: "esquecido@unb.br",
      formacao: "Doutorado",
      senha: "SenhaAntiga123",
      senha_confirmation: "SenhaAntiga123",
      redefinicao_senha_token: "token_redefinicao_456"
    )
  end

  describe "Feature 3: Cadastrar senha (Primeiro Acesso)" do
    it "GET /definir_senha/:token acessa a tela de cadastro" do
      get edit_definicao_senha_path(token: usuario_sem_senha.definicao_senha_token)
      expect(response).to have_http_status(:ok)
    end

    it "PATCH /definir_senha/:token define a senha e redireciona para login" do
      patch definicao_senha_path(token: usuario_sem_senha.definicao_senha_token), params: {
        senha: "NovaSenhaSegura123",
        senha_confirmation: "NovaSenhaSegura123"
      }

      usuario_sem_senha.reload
      expect(usuario_sem_senha.senha_definida?).to be true

      expect(response).to redirect_to(root_path)
    end
  end

  describe "Feature 4: Redefinir senha" do
    it "POST /redefinir_senha solicita a troca e envia email" do
      post redefinir_senha_path, params: { email: usuario_esquecido.email }
      usuario_esquecido.reload

      expect(usuario_esquecido.redefinicao_senha_token).not_to be_nil

      expect(response).to redirect_to(root_path)
    end

    it "PATCH /redefinir_senha/:token salva a nova senha e redireciona" do
      patch redefinicao_senha_path(token: usuario_esquecido.redefinicao_senha_token), params: {
        senha: "SenhaTotalmenteNova1",
        senha_confirmation: "SenhaTotalmenteNova1"
      }

      expect(response).to redirect_to(root_path)
    end
  end
end
