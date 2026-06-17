class AdminController < ApplicationController
  layout "gerenciamento"

  before_action :require_login
  before_action :require_admin
  before_action :set_admin

  def avaliacoes
    @avaliacoes = Formulario
      .joins(:turma)
      .includes(turma: { disciplina: :departamento, docentes: [] })
  end

  def gerenciamento
  end

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

  def resultados
    @formularios = Formulario.joins(turma: :disciplina).where(disciplinas: { departamento_id: @admin.departamento_id }).includes(turma: :disciplina)
  end

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
  def sincronizar_sigaa
    if request.get?
      render :sincronizar_sigaa
    elsif request.post?
      processar_sincronizacao
    end
  end

  private

  def set_admin
    @admin = Administrador.find(params[:admin_id])

    if @admin.id != session[:usuario_id]
      redirect_to inicio_path, alert: "Acesso negado! Você só pode acessar as suas próprias páginas."
    end
  end

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
