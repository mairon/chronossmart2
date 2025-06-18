class ApplicationController < ActionController::Base
  helper_method :current_user
  helper_method :current_unidade
  helper_method :permission_action_user
  helper ApplicationHelper
  before_filter :subdomain_change_database, :set_locale

  def subdomain_change_database
    return if @subdomain_processed # Evita processar múltiplas vezes
    @subdomain_processed = true

    if request.subdomain.present? && request.subdomain != "www"
      # Salva a conexão atual para restaurar em caso de erro
      original_connection = ActiveRecord::Base.connection_config

      begin
        connection_config = website_connection(request.subdomain)

        # Tenta conectar - aqui pode gerar o erro
        ActiveRecord::Base.establish_connection(connection_config)

        # Força uma conexão real para verificar se o banco existe
        ActiveRecord::Base.connection.active?

      rescue PG::ConnectionBad => e
        # Restaura conexão original antes de redirecionar
        ActiveRecord::Base.establish_connection(original_connection)

        Rails.logger.warn "Subdomínio inválido (PG::ConnectionBad): #{request.subdomain} - #{e.message}"
        redirect_to "https://chronos.com.py" and return

      rescue ActiveRecord::DatabaseConnectionError,
             ActiveRecord::ConnectionNotEstablished,
             PG::InvalidCatalogName,
             PG::Error => e

        # Restaura conexão original antes de redirecionar
        ActiveRecord::Base.establish_connection(original_connection)

        Rails.logger.warn "Subdomínio inválido: #{request.subdomain} - #{e.message}"
        redirect_to "https://chronos.com.py" and return

      rescue => e
        # Restaura conexão original antes de redirecionar
        ActiveRecord::Base.establish_connection(original_connection)

        Rails.logger.error "Erro inesperado com subdomínio #{request.subdomain}: #{e.class} - #{e.message}"
        redirect_to "https://chronos.com.py" and return
      end
    end
  end

  # Return regular connection hash but with database name changed
  # The database name is a attribute (column in the database)
  def website_connection(subdomain)
    default_connection.dup.update(:database => subdomain)
  end

  # Regular database.yml configuration hash
  def default_connection
    @default_config ||= ActiveRecord::Base.connection.instance_variable_get("@config").dup
  end

  private

  def current_user
    @current_user ||= Usuario.find(session[:logged]) unless session[:logged] == false
    Auditor::User.current_user = @current_user
  end

  def current_unidade
    @current_unidade ||= Unidade.find(session[:unidade])
    Auditor::Unidade.current_unidade = @current_unidade
  end

  def permission_action_user
    UsuarioPerfil.joins(:menu).where(menus: {url: request.fullpath}, usuario_perfils: {usuario_id: current_user.id} ).last
  end

  def authenticate
    if session[:logged]
      true
    else
      session[:logged] = false
      redirect_to new_login_path
    end
  end

  def set_locale
    I18n.locale = 'es'
  end
end