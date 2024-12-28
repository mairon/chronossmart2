class LoginPainelClienteController < LoginClienteController
  def index
    session[:cliente] = false
    session[:logged]       = false
    session[:empresa_nome] = false

    render layout: 'login_cliente'

  end

  def logar_cliente

    if session[:cliente]
      redirect_to painel_cliente_path
    else

      us = Persona.select('id,nome,senha').where("nome = ? and senha = ?", params[:usuario_nome],params[:usuario_senha])
      puts "Aquiiii===== >>> #{us.count(:id)}"
      if us.count(:id) > 0
        session[:cliente] = params[:usuario_nome]
        flash[:notice]    = t('SUCESSFUL_LOGIN_MESSAGE')

        redirect_to painel_cliente_path

      else

        flash[:notice] = 'Contra-Senha incorreta!!'
        render :action => "index"
      end
    end
  end

  def destroy
    session[:cliente] = false
    redirect_to login_cliente_path
  end
end

