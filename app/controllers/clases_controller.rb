class ClasesController < ApplicationController

  def update_individual
     ClaseTabelaPreco.update(params[:products].keys, params[:products].values)
      redirect_to clase_path(params[:id])
  end

  def index
    @clases = Clase.find(:all, :order => 'id')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @clases }
    end
  end

  # GET /clases/1
  # GET /clases/1.xml
  def show
    @clase = Clase.find(params[:id])
    @unidades_tabelas = ClaseTabelaPreco.where('clase_id = ? and unidade_id = ?', @clase.id, current_unidade.id).order('id')
    render layout: 'chart'
  end

  # GET /clases/new
  # GET /clases/new.xml
  def new
    @clase = Clase.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @clase }
    end
  end

  # GET /clases/1/edit
  def edit
    @clase = Clase.find(params[:id])
  end

  # POST /clases
  # POST /clases.xml
  def create
    @clase = Clase.new(params[:clase])
    @clase.usuario_created = current_user.usuario_nome
    @clase.unidade_created = current_unidade.unidade_nome


    respond_to do |format|
      if @clase.save
        format.html { redirect_to(clase_path(@clase)) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /clases/1
  # PUT /clases/1.xml
  def update
    @clase = Clase.find(params[:id])
    @clase.usuario_updated = current_user.usuario_nome
    @clase.unidade_updated = current_unidade.unidade_nome

    respond_to do |format|
      if @clase.update_attributes(params[:clase])
        
        format.html { redirect_to(clase_path(@clase)) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /clases/1
  # DELETE /clases/1.xml
  def destroy
    @clase = Clase.find(params[:id])
    @clase.destroy

    respond_to do |format|
      format.html { redirect_to(clases_url) }
    end
  end
end
