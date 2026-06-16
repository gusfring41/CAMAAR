require 'rails_helper'

RSpec.describe "Usuarios", type: :request do
  let(:departamento) { Departamento.find_or_create_by!(nome: "Ciência da Computação", codigo: "CIC") }

  let!(:admin) do
    Administrador.create!(
      nome: "Admin Teste",
      matricula: "adm001",
      email: "admin@unb.br",
      senha: "Senha123",
      senha_confirmation: "Senha123",
      departamento: departamento
    )
  end

  let!(:docente) do
    Docente.create!(
      nome: "Prof Teste",
      matricula: "doc001",
      email: "prof@unb.br",
      formacao: "Doutorado",
      senha: "Senha123",
      senha_confirmation: "Senha123"
    )
  end

  def logar_como(usuario)
    post login_path, params: { login: usuario.email, senha: "Senha123" }
  end

  describe "GET /usuarios (require_login)" do
    context "sem sessão ativa" do
      it "redireciona para a tela de login com alerta" do
        get usuarios_path
        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response.body).to include("precisa estar logado")
      end
    end
  end

  describe "GET /usuarios (require_admin)" do
    context "logado como usuário comum" do
      before { logar_como(docente) }

      it "redireciona para a página inicial com alerta de acesso negado" do
        get usuarios_path
        expect(response).to redirect_to(inicio_path)
        follow_redirect!
        expect(response.body).to include("Acesso negado")
      end
    end

    context "logado como Administrador" do
      before { logar_como(admin) }

      it "permite o acesso" do
        get usuarios_path
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "GET /usuarios/:id" do
    context "sem sessão ativa" do
      it "redireciona para a tela de login" do
        get usuario_path(docente)
        expect(response).to redirect_to(root_path)
      end
    end

    context "logado como usuário comum" do
      before { logar_como(docente) }

      it "redireciona para a página inicial" do
        get usuario_path(docente)
        expect(response).to redirect_to(inicio_path)
      end
    end

    context "logado como Administrador" do
      before { logar_como(admin) }

      it "permite o acesso" do
        get usuario_path(docente)
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "DELETE /usuarios/:id" do
    context "sem sessão ativa" do
      it "redireciona para a tela de login" do
        delete usuario_path(docente)
        expect(response).to redirect_to(root_path)
      end
    end

    context "logado como usuário comum" do
      before { logar_como(docente) }

      it "redireciona para a página inicial" do
        delete usuario_path(docente)
        expect(response).to redirect_to(inicio_path)
      end
    end

    context "logado como Administrador" do
      before { logar_como(admin) }

      it "remove o usuário e redireciona para a listagem" do
        delete usuario_path(docente)
        expect(response).to redirect_to(usuarios_path)
      end
    end
  end
end
