class UsuariosController < ApplicationController
before_filter :authenticate

  def resultado_historico_acesso
    acao = "and action = '#{params[:acao]}'" unless params[:action].blank?
    user = "and user_id = #{params[:busca]["usuario"]}" unless params[:busca]["usuario"].blank?
      @auditorias = Audit.select(' created_at,
                  owner_type,
                  user_type,
                  action,
                  comment,
                  cod_processo,
                  audited_changes').where("DATE(created_at) between ? and ? and owner_type = ? #{user} #{acao}", params[:inicio].split("/").reverse.join("-"), params[:final].split("/").reverse.join("-"), params[:processo]).order('created_at')

    
    if params[:print] == 'true'


      head = "                                                                    HISTORIAL DE ACESOS"
      respond_to do |format|
        format.html do
          render  :pdf                    => "resultado_rodados",
                      :layout                 => "layer_relatorios",
                      :margin => {:top        => '0.90in',
                                  :bottom     => '0.25in',
                                  :left       => '0.10in',
                                  :right      => '0.10in'},
                       :header => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                                                                    :font_size  => 7,
                                                                    :left       => head,
                                                                    :spacing    => 10},                                  
                      :footer => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                                  :font_size  => 7,
                                  :right      => "Pagina [page] de [toPage]",
                                  :left       => "CHRONOS SOFTWARE - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
        end
      end
          
    else
      render :layout => false
    end
  end
  
  def gerar_perfil
    @usuario = Usuario.find(params[:id])
    UsuarioPerfil.destroy_all("usuario_id = #{@usuario.id}" )

      menu = Menu.all
      menu.each do |m|
        UsuarioPerfil.create( :usuario_id  => params[:id],
                              :menu_id     => m.id,
                              :codigo      => m.codigo
                               )

    end
    redirect_to(usuario_path(@usuario.id))
  end

  def index
    @usuarios = Usuario.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @usuarios }
    end
  end

  # GET /usuarios/1
  # GET /usuarios/1.xml
  def show
    @usuario = Usuario.find(params[:id])
    @menu = UsuarioPerfil.where("usuario_id = #{@usuario.id}").order("replace(codigo,'.','')").includes(:menu)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @usuario }
    end
  end

  # GET /usuarios/new
  # GET /usuarios/new.xml
  def new
    @usuario = Usuario.new

  end

  # GET /usuarios/1/edit
  def edit
    @usuario = Usuario.find(params[:id])
  end

  # POST /usuarios
  # POST /usuarios.xml
  def create
    @usuario = Usuario.new(params[:usuario])

    respond_to do |format|
      if @usuario.save
        flash[:notice] = t('SAVE_SUCESSFUL_MESSAGE')
        format.html { redirect_to(usuario_path(@usuario)) }
        format.xml  { render :xml => @usuario, :status => :created, :location => @usuario }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @usuario.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /usuarios/1
  # PUT /usuarios/1.xml
  def update
    @usuario = Usuario.find(params[:id])

    respond_to do |format|
      if @usuario.update_attributes(params[:usuario])
        flash[:notice] = t('SUCESSFUL_EDIT_MESSAGE')
        format.html { redirect_to(usuario_path(@usuario)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @usuario.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /usuarios/1
  # DELETE /usuarios/1.xml
  def destroy
    @usuario = Usuario.find(params[:id])
    @usuario.destroy

    respond_to do |format|
      format.html { redirect_to(usuarios_url) }
      format.xml  { head :ok }
    end
  end
end
