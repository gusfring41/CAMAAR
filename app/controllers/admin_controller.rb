class AdminController < ApplicationController
  def index
    # Renderiza a página com os botões de Importar e Atualizar
  end

  def importar_sigaa
    resultado = SigaaImporter.import_from_files("classes.json", "members.json")

    case resultado
    when /sucesso/i
      redirect_to admin_path, notice: "As turmas, matérias e participantes do SIGAA estão presentes no sistema."
    when /alguns dados/i
      redirect_to admin_path, notice: "alguns dados já foram importados e não serão importados novamente, mas os dados restantes serão importados com sucesso"
    when /já existem/i
      redirect_to admin_path, alert: "os dados do SIGAA já existem na base de dados do sistema e não serão importados novamente"
    else
      redirect_to admin_path, alert: "erro informando que a importação falhou"
    end
  end

  def atualizar_sigaa
    resultado = SigaaImporter.update_from_files("classes.json", "members.json")

    case resultado
    when /alguns dados/i
      redirect_to admin_path, notice: "alguns dados já estão atualizados e não serão atualizados novamente, mas os dados restantes serão atualizados com sucesso"
    when /já estão atualizados/i
      redirect_to admin_path, alert: "os dados do SIGAA já estão atualizados e não serão atualizados novamente"
    when /atualiza/i
      redirect_to admin_path, notice: "As turmas, matérias e participantes do SIGAA estão atualizados no sistema com os dados atuais do SIGAA."
    else
      redirect_to admin_path, alert: "erro informando que a atualização falhou"
    end
  end
end
