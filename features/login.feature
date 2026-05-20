#encoding : UTF-8
# language: pt

Funcionalidade: Login no sistema
         Eu, como usuário do sistema
         Quero acessar o sistema utilizando um e-mail ou matrícula cadastrada
         A fim de responder formulários ou gerenciar o sistema

  Cenário: Login realizado com sucesso usando e-mail válido
    Dado que meu e-mail "usuario@teste.com" está cadastrado no sistema
    Quando eu tento fazer login com as credenciais corretas
    Então vejo a mensagem "Login realizado com sucesso."
    E sou direcionado para a página inicial

  Cenário: Login realizado com sucesso usando matrícula válida
    Dado que minha matrícula "261067676" está cadastrada no sistema
    Quando eu tento fazer login com as credenciais corretas
    Então vejo a mensagem "Login realizado com sucesso."
    E sou direcionado para a página inicial

  Cenário: Tentativa de login com a senha errada
    Dado que meu usuário está cadastrado com o email "usuario@teste.com" e senha "Senha123."
    Quando eu tento realizar o login com o email correto e a senha "Senha123"
    Entao vejo a mensagem "Falha no login: senha incorreta"
    E permaneço na página de login

  Cenário: Tentativa de login com senha em branco
    Dado que meu usuário está cadastrado com o email "usuario@teste.com" e senha "Senha123."
    Quando eu tento realizar o login sem informar minha senha
    Entao vejo a mensagem "Falha no login: informe a sua senha"
    E permaneço na página de login

  Cenário: Tentativa de login com usuário não cadastrado
    Dado que meu email "usuario@teste.com" não está cadastrado no sistema
    Quando eu tento realizar o login com este email
    Entao vejo a mensagem "Falha no login: usuário não encontrado"
    E permaneço na página de login