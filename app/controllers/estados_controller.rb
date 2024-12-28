class EstadosController < ApplicationController
before_filter :authenticate

  def index
    @estados = Estado.order('paise_id, nome')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @estados }
    end
  end


  def show
    @estado = Estado.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @estado }
    end
  end


  def new
    @estado = Estado.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @estado }
    end
  end

  def edit
    @estado = Estado.find(params[:id])
  end

  def create
    @estado = Estado.new(params[:estado])
    @estado.usuario_created = current_user.usuario_nome
    @estado.unidade_created = current_unidade.unidade_nome


    respond_to do |format|
      if @estado.save
        flash[:notice] = t('SAVE_SUCESSFUL_MESSAGE')
        format.html { redirect_to(estados_url) }
        format.xml  { render :xml => @estado, :status => :created, :location => @estado }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @estado.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @estado = Estado.find(params[:id])
    @estado.usuario_updated = current_user.usuario_nome
    @estado.unidade_updated = current_unidade.unidade_nome

    respond_to do |format|
      if @estado.update_attributes(params[:estado])
        flash[:notice] = t('SUCESSFUL_EDIT_MESSAGE')
        format.html { redirect_to(estados_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @estado.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @estado = Estado.find(params[:id])
    @estado.destroy

    respond_to do |format|
      format.html { redirect_to(estados_url) }
      format.xml  { head :ok }
    end
  end
end
