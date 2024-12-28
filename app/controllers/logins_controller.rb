class LoginsController < ApplicationController
  before_filter :authenticate, :only => [ :acesso ]
  def acesso
    @password = Login.new
    @list    = Login.all(:order => 'vencimento desc')
  end


  def new
    session[:logged]       = false
    session[:empresa_nome] = false

    puts session[:logged]    

  end

  def create
    @password = Login.new(params[:login])

    respond_to do |format|
      if @password.save
        format.html { redirect_to('/logins/acesso', :notice => t('SAVE_SUCESSFUL_MESSAGE')) }
      else
        format.html { render :action => "acesso" }
      end
    end
  end

  def logar

    if session[:logged] and session[:unidade]
      redirect_to menu_path
    else

      @unidade = Unidade.find(:first, :select =>'id,nome_sys',:conditions   => ['id = ?',params[:busca]["unidade_id"]])
      @login   = Usuario.find(:first, :select =>'id,usuario_senha',:conditions => ['id = ? and usuario_senha = ?',params[:busca]["usuario_id"],params[:usuario_senha]])
      @login_unidade = UnidadesUsuario.find(:first, :select =>'id',:conditions => ['unidade_id = ? and usuario_id = ?',params[:busca]["unidade_id"], params[:busca]["usuario_id"]])

      if @unidade and  @login_unidade and  @login

        session[:unidade]   = params[:busca]["unidade_id"]
        session[:logged]    = params[:busca]["usuario_id"]
        flash[:notice]      = t('SUCESSFUL_LOGIN_MESSAGE')
        session[:empresa_nome] = @unidade.nome_sys

        redirect_to menus_path

      else

        flash[:notice] = 'Contra-Senha incorreta!'
        render :action => "new"

      end
    end
  end

  def liberacao
    @liberacao = Login.find(:last,:conditions => ["senha = ?",params[:senha]])

    if @liberacao

      @liberacao.update_attribute :liberacao,  params[:senha]
      @liberacao.update_attribute :status, 2

      redirect_to new_login_path
    else
      render :action => "liberacao"
    end
  end

  def destroy
    session[:logged] = false
    redirect_to new_login_path
  end

protected

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == "mercosys" && password == "di03051999"
    end
  end
end
