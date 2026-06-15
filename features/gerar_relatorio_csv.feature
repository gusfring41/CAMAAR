# encoding : UTF-8
# language: pt

Funcionalidade: Download de resultados de formulário em CSV
        Eu, como Administrador
        Quero baixar um arquivo csv contendo os resultados de um formulário
        A fim de avaliar o desempenho das turmas

  Contexto:
    Dado que estou autenticado no sistema com o perfil de "Administrador"
    E existe a "Turma A" que possui o formulário "Avaliação Semestral" associado a ela
    E este formulário já possui respostas enviadas pelos alunos

  Cenário: Baixar resultados do formulário com sucesso (happy path)
    Dado que estou na página de detalhes do formulário "Avaliação Semestral" da "Turma A"
    Quando eu clico em "Baixar Resultados (CSV)"
    Então o download do arquivo "resultados_avaliacao_semestral.csv" é iniciado
    E vejo a mensagem "Arquivo exportado com sucesso."
    E o arquivo deve conter as colunas correspondentes aos elementos do formulário e suas respectivas respostas

  Cenário: Tentar baixar CSV de um formulário que não possui respostas (sad path)
    Dado que a "Turma A" possui outro formulário chamado "Questionário Opcional"
    E este formulário não recebeu nenhuma resposta até o momento
    E estou na página de detalhes do formulário "Questionário Opcional"
    Quando eu clico em "Baixar Resultados (CSV)"
    Então vejo a mensagem de erro "Falha na exportação: Este formulário ainda não possui respostas registradas."
    E nenhum download de arquivo é iniciado

  Cenário: Instabilidade no servidor interrompe a geração do CSV (sad path)
    Dado que estou na página de detalhes do formulário "Avaliação Semestral" da "Turma A"
    E o servidor de arquivos encontra-se indisponível no momento
    Quando eu clico em "Baixar Resultados (CSV)"
    Então vejo a mensagem de erro "Falha no sistema: O servidor demorou muito para responder. Tente novamente em instantes."