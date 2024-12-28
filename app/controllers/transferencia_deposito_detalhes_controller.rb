class TransferenciaDepositoDetalhesController < ApplicationController
  before_filter :authenticate

  def index
    @transferencia_deposito_detalhes = TransferenciaDepositoDetalhe.order('id')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @transferencia_deposito_detalhes }
    end
  end

  def show
    @transferencia_deposito_detalhe = TransferenciaDepositoDetalhe.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @transferencia_deposito_detalhe }
    end
  end

  def new
    @transferencia_deposito_detalhe = TransferenciaDepositoDetalhe.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @transferencia_deposito_detalhe }
    end
  end

  def edit
    @transferencia_deposito_detalhe = TransferenciaDepositoDetalhe.find(params[:id])
  end

  def create
    @transferencia_deposito_detalhe = TransferenciaDepositoDetalhe.new(params[:transferencia_deposito_detalhe])

    respond_to do |format|
      if @transferencia_deposito_detalhe.save
        format.html { redirect_to("/transferencia_depositos/#{@transferencia_deposito_detalhe.transferencia_deposito_id} ") }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @transferencia_deposito_detalhe = TransferenciaDepositoDetalhe.find(params[:id])

    respond_to do |format|
      if @transferencia_deposito_detalhe.update_attributes(params[:transferencia_deposito_detalhe])
        format.html { redirect_to("/transferencia_depositos/#{@transferencia_deposito_detalhe.transferencia_deposito_id} ") }
      else
        format.html { render :action => "edit" }
      end
    end  
  end

  def destroy
    @transferencia_deposito_detalhe = TransferenciaDepositoDetalhe.find(params[:id])
    @transferencia_deposito_detalhe.destroy

    respond_to do |format|
      format.html { redirect_to("/transferencia_depositos/#{@transferencia_deposito_detalhe.transferencia_deposito_id} ") }
    end
      
  end  
end
