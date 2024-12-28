class TransferenciaContasDetalhesController < ApplicationController
  # GET /transferencia_contas_detalhes
  # GET /transferencia_contas_detalhes.xml
  def index
    @transferencia_contas_detalhes = TransferenciaContasDetalhe.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @transferencia_contas_detalhes }
    end
  end

  # GET /transferencia_contas_detalhes/1
  # GET /transferencia_contas_detalhes/1.xml
  def show
    @transferencia_contas_detalhe = TransferenciaContasDetalhe.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @transferencia_contas_detalhe }
    end
  end

  # GET /transferencia_contas_detalhes/new
  # GET /transferencia_contas_detalhes/new.xml
  def new
    @transferencia_contas_detalhe = TransferenciaContasDetalhe.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @transferencia_contas_detalhe }
    end
  end

  # GET /transferencia_contas_detalhes/1/edit
  def edit
    @transferencia_contas_detalhe = TransferenciaContasDetalhe.find(params[:id])
  end

  # POST /transferencia_contas_detalhes
  # POST /transferencia_contas_detalhes.xml
  def create
    @transferencia_contas_detalhe = TransferenciaContasDetalhe.new(params[:transferencia_contas_detalhe])

    respond_to do |format|
      if @transferencia_contas_detalhe.save
        format.html { redirect_to("/transferencia_contas/#{@transferencia_contas_detalhe.transferencia_conta_id}") }
        format.xml  { render :xml => @transferencia_contas_detalhe, :status => :created, :location => @transferencia_contas_detalhe }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @transferencia_contas_detalhe.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /transferencia_contas_detalhes/1
  # PUT /transferencia_contas_detalhes/1.xml
  def update
    @transferencia_contas_detalhe = TransferenciaContasDetalhe.find(params[:id])

    respond_to do |format|
      if @transferencia_contas_detalhe.update_attributes(params[:transferencia_contas_detalhe])
        format.html { redirect_to("/transferencia_contas/#{@transferencia_contas_detalhe.transferencia_conta_id}") }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @transferencia_contas_detalhe.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /transferencia_contas_detalhes/1
  # DELETE /transferencia_contas_detalhes/1.xml
  def destroy
    @transferencia_contas_detalhe = TransferenciaContasDetalhe.find(params[:id])
    @transferencia_contas_detalhe.destroy

    respond_to do |format|
        format.html { redirect_to("/transferencia_contas/#{@transferencia_contas_detalhe.transferencia_conta_id}") }
      format.xml  { head :ok }
    end
  end
end
