class LoginClienteController < ActionController::Base
  protect_from_forgery

  helper_method :current_cliente
  helper ApplicationHelper
  before_filter :subdomain_change_database

  def subdomain_change_database
    if request.subdomain.present? && request.subdomain != "www"
      ActiveRecord::Base.establish_connection(website_connection(request.subdomain))
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
  def current_cliente
    @current_cliente ||= Persona.find_by_nome(session[:cliente],:select => 'id,nome')
  end

  def authenticate
    if session[:cliente]
      true
    else
      redirect_to login_cliente_path
    end
  end

end
