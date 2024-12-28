class SueldosDetalhesController < ApplicationController

  def index
    @sueldos_detalhes = SueldosDetalhe.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @sueldos_detalhes }
    end
  end

  def show
    @sueldos_detalhe = SueldosDetalhe.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @sueldos_detalhe }
    end
  end

  def new
    @sueldos_detalhe = SueldosDetalhe.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @sueldos_detalhe }
    end
  end

  def edit
    @sueldos_detalhe = SueldosDetalhe.find(params[:id])
  end

  def create
    @sueldos_detalhe = SueldosDetalhe.new(params[:sueldos_detalhe])
    @sueldos_detalhe.usuario_created = current_user.id
    @sueldos_detalhe.unidade_created = current_unidade.id

    respond_to do |format|
      if @sueldos_detalhe.save
        format.html { redirect_to "/sueldos/#{@sueldos_detalhe.sueldo_id}", :notice => t('SAVE_SUCESSFUL_MESSAGE') }
        format.xml  { render :xml => @sueldos_detalhe, :status => :created, :location => @sueldos_detalhe }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @sueldos_detalhe.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @sueldos_detalhe = SueldosDetalhe.find(params[:id])
    @sueldos_detalhe.usuario_updated = current_user.id
    @sueldos_detalhe.unidade_updated = current_unidade.id

    respond_to do |format|
      if @sueldos_detalhe.update_attributes(params[:sueldos_detalhe])
        format.html { redirect_to "/sueldos/#{@sueldos_detalhe.sueldo_id}", :notice => t('SUCESSFUL_EDIT_MESSAGE') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @sueldos_detalhe.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /sueldos_detalhes/1
  # DELETE /sueldos_detalhes/1.xml
  def destroy
    @sueldos_detalhe = SueldosDetalhe.find(params[:id])
    @sueldos_detalhe.destroy

    respond_to do |format|
      format.html { redirect_to "/sueldos/#{@sueldos_detalhe.sueldo_id}" }
      format.xml  { head :ok }
    end
  end
end
