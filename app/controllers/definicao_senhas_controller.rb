class DefinicaoSenhasController < ApplicationController
  # Exibe o formulário de definição de senha via token enviado por email.
  #
  # @return [void]
  # @note Lê o parâmetro +:token+ da rota. Redireciona para a página raiz com alerta
  #   se o token for inválido ou não corresponder a nenhum usuário.
  def edit
    @usuario = Usuario.find_by(definicao_senha_token: params[:token])

    return if @usuario.present?

    redirect_to root_path, alert: "Link de definição de senha inválido."
  end

  # Persiste a nova senha para o usuário identificado pelo token.
  #
  # @return [void]
  # @note Lê os parâmetros +:token+, +:senha+ e +:senha_confirmation+.
  #   Redireciona com alerta se o token for inválido, as senhas não conferirem ou a
  #   senha tiver menos de 6 caracteres. Em caso de sucesso, limpa o token e a data
  #   de envio, salva a nova senha no banco de dados e redireciona para a página raiz.
  def update
    @usuario = Usuario.find_by(definicao_senha_token: params[:token])

    if @usuario.blank?
      redirect_to root_path, alert: "Link de definição de senha inválido."
      return
    end

    nova_senha = params[:senha].to_s
    confirmacao = params[:senha_confirmation].to_s

    if nova_senha != confirmacao
      flash.now[:alert] = "Falha na definição de senha: confirmação não confere"
      render :edit, status: :unprocessable_content
      return
    end

    if nova_senha.length < 6
      flash.now[:alert] = "Falha na definição de senha: senha inválida"
      render :edit, status: :unprocessable_content
      return
    end

    @usuario.senha = nova_senha
    @usuario.senha_confirmation = confirmacao
    @usuario.definicao_senha_token = nil
    @usuario.definicao_senha_sent_at = nil

    if @usuario.save
      redirect_to root_path, notice: "Senha definida com sucesso."
    else
      flash.now[:alert] = "Falha na definição de senha: senha inválida"
      render :edit, status: :unprocessable_content
    end
  end
end
