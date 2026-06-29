class AdminController < ApplicationController
  layout "gerenciamento"

  before_action :require_login
  before_action :require_admin
  before_action :set_admin

  # Lista todos os formulários com suas turmas, disciplinas, departamentos e docentes.
  #
  # @return [void]
  def avaliacoes
    @avaliacoes = Formulario
      .joins(:turma)
      .includes(turma: { disciplina: :departamento, docentes: [] })
  end

  # Exibe a página de gerenciamento do administrador.
  #
  # @return [void]
  def gerenciamento
  end

  # Exibe o formulário de envio de avaliações (GET) ou cria formulários a partir de um
  # template para as turmas selecionadas (POST).
  #
  # @return [void]
  # @note GET: popula +@templates+ e +@turmas+ para exibição do formulário de seleção.
  #   POST: lê os parâmetros +:template_id+ e +:turma_ids+; redireciona com alerta se
  #   algum estiver ausente. Em caso de sucesso, cria um +Formulario+ para cada turma
  #   com os +ElementoForm+ e +CampoForm+ derivados do template, depois redireciona para
  #   a página de gerenciamento.
  def enviar_formularios
    if request.get?
      @templates = Template.where(usuario_id: @admin.id)
      @turmas = Turma.joins(:disciplina).includes(:disciplina).order("disciplinas.nome, turmas.semestre")
    elsif request.post?
      template_id = params[:template_id]
      turma_ids = params[:turma_ids]

      if template_id.blank?
        flash[:alert] = "Selecione um template para criar o formulário"
        redirect_to admin_enviar_formularios_path(@admin) and return
      end

      if turma_ids.blank?
        flash[:alert] = "Selecione pelo menos uma turma"
        redirect_to admin_enviar_formularios_path(@admin) and return
      end

      template = Template.includes(elementos: :campos).find(template_id)
      turmas = Turma.where(id: turma_ids)

      turmas.each do |turma|
        formulario = Formulario.create!(
          turma: turma,
          titulo: "#{turma.disciplina.nome} - #{turma.semestre}"
        )

        template.elementos.each_with_index do |elemento, _i|
          tipo = elemento.campos.first&.tipo_elemento || "Texto"
          ef = formulario.elemento_forms.create!(
            enunciado: elemento.enunciado,
            ordem: elemento.ordem,
            tipo: tipo
          )

          next if tipo == "Texto"

          elemento.campos.each do |campo|
            ef.campo_forms.create!(
              enunciado: campo.enunciado,
              ordem: campo.ordem
            )
          end
        end
      end

      msg = turma_ids.size == 1 ? "Formulário criado com sucesso" : "Formulários criados com sucesso"
      flash[:notice] = msg
      redirect_to admin_gerenciamento_path(@admin)
    end
  end

  # Lista os formulários pertencentes às disciplinas do departamento do administrador.
  #
  # @return [void]
  def resultados
    @formularios = Formulario.joins(turma: :disciplina).where(disciplinas: { departamento_id: @admin.departamento_id }).includes(turma: :disciplina)
  end

  # Exporta as respostas de um formulário como arquivo CSV para download.
  #
  # @return [void]
  # @note Lê o parâmetro +:id+ da rota. Redireciona com alerta se o formulário não for
  #   encontrado ou não possuir respostas. Em caso de sucesso, força o download do arquivo
  #   CSV nomeado com o id do formulário, número da turma e nome da matéria.
  def exportar_csv
    @formulario = Formulario.find_by(id: params[:id])

    if @formulario
      # O .includes carrega o usuário e também os resposta_elems junto com seus respectivo elemento_form
      @respostas = RespostaForm.where(formulario_id: @formulario.id).includes(:usuario, resposta_elems: :elemento_form)

      if @formulario.resposta_forms.empty?
        redirect_to admin_resultados_path(@admin), alert: "Falha na exportação: Este formulário ainda não possui respostas registradas."
        return
      end

      respond_to do |format|
        format.csv do
          num_turma = @formulario.turma&.numero_da_turma&.parameterize(separator: "_") || "sem_turma"
          nome_materia = @formulario.turma&.disciplina&.nome&.parameterize(separator: "_") || "sem_materia"
          nome_arquivo = "formulario_#{@formulario.id}_turma_#{num_turma}_#{nome_materia}.csv"

          # Força o download
          response.headers["Content-Disposition"] = "attachment; filename=\"#{nome_arquivo}\""
        end
      end
    else
      redirect_to admin_resultados_path(@admin), alert: "Formulário não encontrado"
    end
  end

  # Exibe a página de sincronização com o SIGAA (GET) ou processa a sincronização (POST).
  #
  # @return [void]
  # @note GET: renderiza a view +sincronizar_sigaa+.
  #   POST: delega o processamento para +processar_sincronizacao+.
  def sincronizar_sigaa
    if request.get?
      render :sincronizar_sigaa
    elsif request.post?
      processar_sincronizacao
    end
  end

  private

  # Busca e valida o administrador referenciado pela rota.
  #
  # @return [void]
  # @note Redireciona para a página inicial com alerta se o administrador da rota for
  #   diferente do usuário autenticado na sessão.
  def set_admin
    @admin = Administrador.find(params[:admin_id])

    if @admin.id != session[:usuario_id]
      redirect_to inicio_path, alert: "Acesso negado! Você só pode acessar as suas próprias páginas."
    end
  end

  # Lê os arquivos enviados via POST e delega a importação ou atualização ao SigaaImporter.
  #
  # @return [void]
  # @note Lê os parâmetros +:acao+, +:arquivo_classes+ e +:arquivo_membros+.
  #   Redireciona com alerta se algum arquivo estiver ausente.
  #   Chama +SigaaImporter.import_from_files+ para a ação "importar" ou
  #   +SigaaImporter.update_from_files+ para "atualizar", depois delega o resultado
  #   a +processar_resultado+.
  def processar_sincronizacao
    acao = params[:acao]
    arquivo_classes = params[:arquivo_classes]
    arquivo_membros = params[:arquivo_membros]

    unless arquivo_classes.present? && arquivo_membros.present?
      redirect_to admin_gerenciamento_path, alert: "Por favor, selecione os dois arquivos JSON"
      return
    end

    resultado = case acao
    when "importar"
                  SigaaImporter.import_from_files(arquivo_classes.path, arquivo_membros.path)
    when "atualizar"
                  SigaaImporter.update_from_files(arquivo_classes.path, arquivo_membros.path)
    else
                  "ação inválida"
    end

    processar_resultado(resultado, acao)
  end

  # Redireciona para a página de gerenciamento com mensagem apropriada ao resultado
  # da importação ou atualização do SIGAA.
  #
  # @param resultado [String] mensagem retornada pelo +SigaaImporter+
  # @param acao [String] "importar" ou "atualizar"
  # @return [void]
  # @note Redireciona para +admin_gerenciamento_path+ em todos os casos, variando apenas
  #   o tipo (notice/alert) e o texto da mensagem conforme o conteúdo de +resultado+.
  def processar_resultado(resultado, acao)
    case resultado
    when /alguns dados/i
      if acao == "importar"
        redirect_to admin_gerenciamento_path(@admin), notice: "alguns dados já foram importados e não serão importados novamente, mas os dados restantes serão importados com sucesso"
      else
        redirect_to admin_gerenciamento_path(@admin), notice: "alguns dados já estão atualizados e não serão atualizados novamente, mas os dados restantes serão atualizados com sucesso"
      end
    when /sucesso/i
      if acao == "importar"
        redirect_to admin_gerenciamento_path(@admin), notice: "As turmas, matérias e participantes do SIGAA estão presentes no sistema."
      else
        redirect_to admin_gerenciamento_path(@admin), notice: "As turmas, matérias e participantes do SIGAA estão atualizados no sistema com os dados atuais do SIGAA."
      end
    when /já existem/i
      redirect_to admin_gerenciamento_path(@admin), alert: "os dados do SIGAA já existem na base de dados do sistema e não serão importados novamente"
    when /já estão atualizados/i
      redirect_to admin_gerenciamento_path(@admin), alert: "os dados do SIGAA já estão atualizados e não serão atualizados novamente"
    else
      nome_acao = acao == "importar" ? "importação" : "atualização"
      redirect_to admin_gerenciamento_path(@admin), alert: "erro informando que a #{nome_acao} falhou"
    end
  end
end
