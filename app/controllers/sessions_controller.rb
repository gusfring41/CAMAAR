class SessionsController < ApplicationController
  def new
    if current_user
      redirect_para_pagina_do_usuario(current_user)
    end
  end

  def create
    login = params[:login].to_s.strip
    senha = params[:senha].to_s

    if login.blank?
      redirect_to root_path, alert: "Falha no login: informe seu email ou matrícula"
      return
    end

    if senha.blank?
      redirect_to root_path, alert: "Falha no login: informe a sua senha"
      return
    end

    usuario = Usuario.find_by(email: login) || Usuario.find_by(matricula: login)

    if usuario.blank?
      redirect_to root_path, alert: "Falha no login: usuário não encontrado"
      return
    end

    unless usuario.senha_definida?
      redirect_to root_path, alert: "Falha no login: usuário existente deve efetivar o seu cadastro por email"
      return
    end

    unless usuario.autenticar_senha(senha)
      redirect_to root_path, alert: "Falha no login: senha incorreta"
      return
    end

    session[:usuario_id] = usuario.id
    redirect_para_pagina_do_usuario(usuario)
  end

  def destroy
    reset_session
    redirect_to root_path
  end

  private

  def redirect_para_pagina_do_usuario(usuario)
    if usuario.is_a?(Administrador)
      redirect_to admin_avaliacoes_path(usuario.id)
    else
      redirect_to usuario_path(usuario.id)
    end
  end
end
