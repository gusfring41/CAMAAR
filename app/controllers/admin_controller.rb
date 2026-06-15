class AdminController < ApplicationController
  layout 'gerenciamento'

  def avaliacoes
  end

  def gerenciamento
  end

  def resultados
    @admin = Administrador.find_by(id: session[:usuario_id])

    if @admin
      @formularios = Formulario.joins(turma: :disciplina).where(disciplinas: { departamento_id: @admin.departamento_id }).includes(turma: :disciplina)
    else
      redirect_to root_path, alert: "Acesso não autorizado."
    end
  end

  def exportar_csv
    @formulario = Formulario.find_by(id: params[:id])

    if @formulario
      # O .includes carrega o usuário e também os resposta_elems junto com seus respectivo elemento_form
      @respostas = RespostaForm.where(formulario_id: @formulario.id).includes(:usuario, resposta_elems: :elemento_form)
      
      if @formulario.resposta_forms.empty?
        redirect_to admin_resultados_path,alert: "Falha na exportação: Este formulário ainda não possui respostas registradas."
        return
      end

      respond_to do |format|
        format.csv do
          num_turma = @formulario.turma&.numero_da_turma&.parameterize(separator: '_') || "sem_turma"
          nome_materia = @formulario.turma&.disciplina&.nome&.parameterize(separator: '_') || "sem_materia"
          nome_arquivo = "formulario_#{@formulario.id}_turma_#{num_turma}_#{nome_materia}.csv"

          # Força o download
          response.headers['Content-Disposition'] = "attachment; filename=\"#{nome_arquivo}\""
        end
      end
    else
      redirect_to admin_resultados_path, alert: "Formulário não encontrado"
    end
  end

  def importar_sigaa
    resultado = SigaaImporter.import_from_files("classes.json", "members.json")

    case resultado
    when /sucesso/i
      redirect_to admin_gerenciamento_path, notice: "As turmas, matérias e participantes do SIGAA estão presentes no sistema."
    when /alguns dados/i
      redirect_to admin_gerenciamento_path, notice: "alguns dados já foram importados e não serão importados novamente, mas os dados restantes serão importados com sucesso"
    when /já existem/i
      redirect_to admin_gerenciamento_path, alert: "os dados do SIGAA já existem na base de dados do sistema e não serão importados novamente"
    else
      redirect_to admin_gerenciamento_path, alert: "erro informando que a importação falhou"
    end
  end

  def atualizar_sigaa
    resultado = SigaaImporter.update_from_files("classes.json", "members.json")

    case resultado
    when /alguns dados/i
      redirect_to admin_gerenciamento_path, notice: "alguns dados já estão atualizados e não serão atualizados novamente, mas os dados restantes serão atualizados com sucesso"
    when /já estão atualizados/i
      redirect_to admin_gerenciamento_path, alert: "os dados do SIGAA já estão atualizados e não serão atualizados novamente"
    when /atualiza/i
      redirect_to admin_gerenciamento_path, notice: "As turmas, matérias e participantes do SIGAA estão atualizados no sistema com os dados atuais do SIGAA."
    else
      redirect_to admin_gerenciamento_path, alert: "erro informando que a atualização falhou"
    end
  end
end
