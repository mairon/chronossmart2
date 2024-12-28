class UnidadesController < ApplicationController
before_filter :authenticate
  # GET /unidades
  # GET /unidades.xml
  def index
    @unidades = Unidade.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @unidades }
    end
  end

  # GET /unidades/1
  # GET /unidades/1.xml
  def show
    @unidade = Unidade.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @unidade }
    end
  end

  # GET /unidades/new
  # GET /unidades/new.xml
  def new
    @unidade = Unidade.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @unidade }
    end
  end

  # GET /unidades/1/edit
  def edit
    @unidade = Unidade.find(params[:id])
  end

  # POST /unidades
  # POST /unidades.xml
  def create
    @unidade = Unidade.new(params[:unidade])

    respond_to do |format|
      if @unidade.save
        flash[:notice] = t('SAVE_SUCESSFUL_MESSAGE')
        format.html { redirect_to(unidades_url) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /unidades/1
  # PUT /unidades/1.xml
  def update
    @unidade = Unidade.find(params[:id])

    respond_to do |format|
      if @unidade.update_attributes(params[:unidade])
        if params[:pagina] == 'start-guide'
          format.html { redirect_to(menus_url) }
        else
          format.html { redirect_to(unidades_url) }
        end
        
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /unidades/1
  # DELETE /unidades/1.xml
  def destroy
    @unidade = Unidade.find(params[:id])
    @unidade.destroy

    respond_to do |format|
      format.html { redirect_to(unidades_url) }
      format.xml  { head :ok }
    end
  end
end
