class HomeController < ApplicationController
  before_action :require_login

  # Exibe a página inicial da aplicação.
  #
  # @return [void]
  def index
  end
end
