class SigaaImporter
  def self.import_from_files(classes_path, members_path)
    created = 0
    ignored = 0

    ActiveRecord::Base.transaction do
      # classes.json
      classes = JSON.parse(File.read(classes_path))
      classes.each do |c|
        disciplina = Disciplina.find_or_create_by(codigo: c["code"]) do |d|
          d.nome = c["name"]
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
          dep = Departamento.find_or_create_by(nome: m["docente"]["departamento"]) if m["docente"]["departamento"]
          usuario = Usuario.find_or_create_by(usuario: m["docente"]["usuario"]) do |u|
            u.nome = m["docente"]["nome"]
            u.email = m["docente"]["email"]
          end
          docente = Docente.find_or_create_by(usuario: usuario.usuario) do |dct|
            dct.nome = usuario.nome
            dct.email = usuario.email
            dct.departamento = dep if dep
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
          curso = Curso.find_or_create_by(nome: aluno["curso"]) if aluno["curso"]
          usuario = Usuario.find_or_create_by(matricula: aluno["matricula"]) do |u|
            u.nome = aluno["nome"]
            u.email = aluno["email"]
          end
          discente = Discente.find_or_create_by(matricula: aluno["matricula"]) do |d|
            d.nome = usuario.nome
            d.usuario = usuario.usuario if usuario.respond_to?(:usuario)
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
          dep = Departamento.find_or_create_by(nome: m["docente"]["departamento"]) if m["docente"]["departamento"]
          usuario = Usuario.find_by(usuario: m["docente"]["usuario"])
          usuario.update(nome: m["docente"]["nome"], email: m["docente"]["email"]) if usuario
          docente = Docente.find_by(usuario: m["docente"]["usuario"])
          docente.update(nome: m["docente"]["nome"], email: m["docente"]["email"], departamento: dep) if docente
          docente.turmas << turma unless docente.turmas.exists?(turma.id)
        end

        Array(m["dicente"]).each do |aluno|
          next unless aluno.is_a?(Hash)
          curso = Curso.find_or_create_by(nome: aluno["curso"]) if aluno["curso"]
          usuario = Usuario.find_by(matricula: aluno["matricula"])
          usuario.update(nome: aluno["nome"], email: aluno["email"]) if usuario
          discente = Discente.find_by(matricula: aluno["matricula"])
          discente.update(nome: aluno["nome"], curso: curso) if discente
          discente.turmas << turma unless discente.turmas.exists?(turma.id)
        end
      end
    end

    "atualização realizada com sucesso"
  rescue StandardError => _e
    "a atualização falhou"
  end
end
