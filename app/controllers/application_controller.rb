class ApplicationController < ActionController::Base

  helper_method :current_user
  helper_method :current_unidade
  helper ApplicationHelper
  before_filter :subdomain_change_database, :set_locale


  def subdomain_change_database
    if request.subdomain.present? && request.subdomain != "www"
      if request.subdomain == 'tresfronteira'
        ActiveRecord::Base.establish_connection('development-s1')
      else
        ActiveRecord::Base.establish_connection(website_connection(request.subdomain))
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



