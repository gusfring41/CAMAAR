class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  helper_method :current_user

  def current_user
    @current_user ||= Usuario.find_by(id: session[:usuario_id])
  end

  def require_login
    unless current_user
      redirect_to root_path, alert: "Você precisa estar logado para acessar esta página."
    end
  end

  def require_admin
    unless current_user.is_a?(Administrador)
      redirect_to inicio_path, alert: "Acesso negado."
    end
  end
end
