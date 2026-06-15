Dado('que estou na página de gerenciamento') do
  # expect(page).to have_current_path(gerenciamento_path)
  # implementar quando o nome da rota for determinado
end

Dado('que eu importei os dados do SIGAA com sucesso') do
  # implementar a partir da feature de importar dados
end

Então('um email de definição de senha é enviado para o email {string}') do |email|
  usuario = Usuario.find_by!(email: email)
  ActionMailer::Base.deliveries.clear
  usuario.enviar_email_definicao_senha!

  @email_destino = email

  enviados = ActionMailer::Base.deliveries.select { |m| m.to == [ email ] }
  expect(enviados).not_to be_empty
end
