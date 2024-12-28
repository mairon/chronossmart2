class CidadesController < ApplicationController
  before_filter :authenticate

  def index
    @cidades = Cidade.includes('paise').includes('estado').includes('regiao').order('paise_id,estado_id,regiao_id, nome')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @cidades }
    end
  end

  # GET /cidades/1
  # GET /cidades/1.xml
  def show
    @cidade = Cidade.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @cidade }
    end
  end

  # GET /cidades/new
  # GET /cidades/new.xml
  def new
    @cidade = Cidade.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @cidade }
    end
  end

  # GET /cidades/1/edit
  def edit
    @cidade = Cidade.find(params[:id])
  end

  def create
    @cidade = Cidade.new(params[:cidade])
    @cidade.usuario_created = current_user.usuario_nome
    @cidade.unidade_created = current_unidade.unidade_nome

    respond_to do |format|
      if @cidade.save
        flash[:notice] = t('SAVE_SUCESSFUL_MESSAGE')
        format.html { redirect_to(cidades_url) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @cidade = Cidade.find(params[:id])
    @cidade.usuario_updated = current_user.usuario_nome
    @cidade.unidade_updated = current_unidade.unidade_nome

    respond_to do |format|
      if @cidade.update_attributes(params[:cidade])
        flash[:notice] = t('SUCESSFUL_EDIT_MESSAGE')
        format.html { redirect_to(cidades_url) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /cidades/1
  # DELETE /cidades/1.xml
  def destroy
    @cidade = Cidade.find(params[:id])
    @cidade.destroy

    respond_to do |format|
      format.html { redirect_to(cidades_url) }
      format.xml  { head :ok }
    end
  end


  def dynamic_estados
    @estados = Estado.where("paise_id = #{params[:id]}").select('nome,id').order('nome')
    respond_to do |format|
      format.js
    end
  end


  def dynamic_regioes
    @estados = Regiao.where("estado_id = #{params[:id]}").select('nome,id').order('nome')
    respond_to do |format|
      format.js
    end
  end

end
