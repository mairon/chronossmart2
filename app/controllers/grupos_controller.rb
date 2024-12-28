class GruposController < ApplicationController
before_filter :authenticate

  def index
    @grupos = Grupo.find(:all, :order => 'id')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @grupos }
    end
  end

  def show
    @grupo = Grupo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @grupo }
    end
  end

  def new
    @grupo = Grupo.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @grupo }
    end
  end

  def edit
    @grupo = Grupo.find(params[:id])
  end

  def create
    @grupo = Grupo.new(params[:grupo])
    @grupo.usuario_created = current_user.usuario_nome
    @grupo.unidade_created = current_unidade.unidade_nome

    respond_to do |format|
      if @grupo.save
        flash[:notice] = t('SAVE_SUCESSFUL_MESSAGE')
        format.html { redirect_to(grupos_url) }
        format.xml  { render :xml => @grupo, :status => :created, :location => @grupo }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @grupo.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @grupo = Grupo.find(params[:id])
    @grupo.usuario_updated = current_user.usuario_nome
    @grupo.unidade_updated = current_unidade.unidade_nome

    respond_to do |format|
      if @grupo.update_attributes(params[:grupo])
        flash[:notice] = t('SUCESSFUL_EDIT_MESSAGE')
        format.html { redirect_to(grupos_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @grupo.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /grupos/1
  # DELETE /grupos/1.xml
  def destroy
    @grupo = Grupo.find(params[:id])
    @grupo.destroy

    respond_to do |format|
      format.html { redirect_to(grupos_url) }
      format.xml  { head :ok }
    end
  end
end
