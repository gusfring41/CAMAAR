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

    return redirecionar_token_invalido unless @usuario.present?
    return render_erro_senha("confirmação não confere") unless senhas_iguais?
    return render_erro_senha("senha inválida") unless senha_valida?

    atribuir_nova_senha

    if @usuario.save
      redirect_to root_path, notice: "Senha definida com sucesso."
    else
      render_erro_senha("senha inválida")
    end
  end

  private

  def redirecionar_token_invalido
    redirect_to root_path, alert: "Link de definição de senha inválido."
  end

  def render_erro_senha(mensagem)
    flash.now[:alert] = "Falha na definição de senha: #{mensagem}"
    render :edit, status: :unprocessable_content
  end

  def senhas_iguais?
    params[:senha].to_s == params[:senha_confirmation].to_s
  end

  def senha_valida?
    params[:senha].to_s.length >= 6
  end

  def atribuir_nova_senha
    @usuario.senha = params[:senha].to_s
    @usuario.senha_confirmation = params[:senha_confirmation].to_s
    @usuario.definicao_senha_token = nil
    @usuario.definicao_senha_sent_at = nil
  end
end