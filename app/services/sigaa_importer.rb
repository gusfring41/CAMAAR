class SigaaImporter
  def self.import_from_files(classes_path, members_path)
    created = 0
    ignored = 0

    ActiveRecord::Base.transaction do
      dep_padrao = Departamento.find_or_create_by(codigo: "NAO_ESP") { |d| d.nome = "Não especificado" }

      # classes.json
      classes = JSON.parse(File.read(classes_path))
      classes.each do |c|
        disciplina = Disciplina.find_or_create_by(codigo: c["code"]) do |d|
          d.nome = c["name"]
          d.departamento = dep_padrao
        end

        class_info = c["class"] || {}
        turma = Turma.find_or_create_by(disciplina: disciplina, numero_da_turma: class_info["classCode"], semestre: class_info["semester"]) do |t|
          t.horario = class_info["time"]
        end

        if turma.created_at == turma.updated_at
          created += 1
        else
          ignored += 1
        end
      end

      # class_members.json
      members = JSON.parse(File.read(members_path))
      members.each do |m|
        code = m.dig("class", "code") || m["code"]
        class_code = m.dig("class", "classCode") || m["classCode"]
        semester = m.dig("class", "semester") || m["semester"]

        disciplina = Disciplina.find_by(codigo: code)
        turma = Turma.find_by(disciplina: disciplina, numero_da_turma: class_code, semestre: semester)
        next unless turma

        # docente
        if m["docente"].is_a?(Hash)
          dep_nome = m["docente"]["departamento"]
          dep = if dep_nome.present?
            dep_cod = dep_nome.parameterize(separator: "_").upcase.first(20)
            Departamento.find_or_create_by(codigo: dep_cod) { |d| d.nome = dep_nome }
          else
            dep_padrao
          end
          docente = Docente.find_or_create_by(email: m["docente"]["email"]) do |dct|
            dct.nome = m["docente"]["nome"]
            dct.matricula = m["docente"]["matricula"] || m["docente"]["usuario"]
            dct.formacao = m["docente"]["formacao"] || "docente"
            dct.departamento = dep
          end
          unless docente.turmas.exists?(turma.id)
            docente.turmas << turma
            created += 1
          else
            ignored += 1
          end
        end

        # discentes
        Array(m["dicente"]).each do |aluno|
          next unless aluno.is_a?(Hash)
          curso = if aluno["curso"].present?
            curso_cod = aluno["curso"].parameterize(separator: "_").upcase.first(30)
            Curso.find_or_create_by(codigo: curso_cod) do |c|
              c.nome = aluno["curso"]
              c.departamento = dep_padrao
            end
          end
          discente = Discente.find_or_create_by(matricula: aluno["matricula"]) do |d|
            d.nome = aluno["nome"]
            d.email = aluno["email"]
            d.formacao = aluno["formacao"] || "graduando"
            d.curso = curso if curso
          end
          unless discente.turmas.exists?(turma.id)
            discente.turmas << turma
            created += 1
          else
            ignored += 1
          end
        end
      end
    end

    if created > 0 && ignored > 0
      "alguns dados já foram importados e não serão importados novamente, mas os dados restantes foram importados com sucesso"
    elsif created == 0
      "os dados já existem e não foram duplicados"
    else
      "importação realizada com sucesso"
    end
  rescue StandardError => _e
    "a importação falhou"
  end

  def self.update_from_files(classes_path, members_path)
    ActiveRecord::Base.transaction do
      classes = JSON.parse(File.read(classes_path))
      classes.each do |c|
        disciplina = Disciplina.find_by(codigo: c["code"])
        disciplina.update(nome: c["name"]) if disciplina

        class_info = c["class"] || {}
        turma = Turma.find_by(disciplina: disciplina, numero_da_turma: class_info["classCode"], semestre: class_info["semester"])
        turma.update(horario: class_info["time"]) if turma
      end

      members = JSON.parse(File.read(members_path))
      members.each do |m|
        code = m.dig("class", "code") || m["code"]
        class_code = m.dig("class", "classCode") || m["classCode"]
        semester = m.dig("class", "semester") || m["semester"]

        disciplina = Disciplina.find_by(codigo: code)
        turma = Turma.find_by(disciplina: disciplina, numero_da_turma: class_code, semestre: semester)
        next unless turma

        if m["docente"].is_a?(Hash)
          dep_nome = m["docente"]["departamento"]
          dep = if dep_nome.present?
            dep_cod = dep_nome.parameterize(separator: "_").upcase.first(20)
            Departamento.find_or_create_by(codigo: dep_cod) { |d| d.nome = dep_nome }
          end
          docente = Docente.find_by(email: m["docente"]["email"])
          if docente
            docente.update(nome: m["docente"]["nome"], departamento: dep || docente.departamento)
            docente.turmas << turma unless docente.turmas.exists?(turma.id)
          end
        end

        Array(m["dicente"]).each do |aluno|
          next unless aluno.is_a?(Hash)
          curso = if aluno["curso"].present?
            curso_cod = aluno["curso"].parameterize(separator: "_").upcase.first(30)
            Curso.find_by(codigo: curso_cod) || Curso.find_by(nome: aluno["curso"])
          end
          discente = Discente.find_by(matricula: aluno["matricula"])
          if discente
            discente.update(nome: aluno["nome"], email: aluno["email"], curso: curso || discente.curso)
            discente.turmas << turma unless discente.turmas.exists?(turma.id)
          end
        end
      end
    end

    "atualização realizada com sucesso"
  rescue StandardError => _e
    "a atualização falhou"
  end
end
