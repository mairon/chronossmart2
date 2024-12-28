class TransferenciaDepositosController < ApplicationController
  before_filter :authenticate
  def transf_deposito_origem
    @deposito = Deposito.find_all_by_unidade_id(params[:id])
    respond_to do |format|
      format.js
    end    
  end

  def transf_deposito_destino
    @deposito = Deposito.find_all_by_unidade_id(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def index
    @transferencia_depositos = TransferenciaDeposito.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @transferencia_depositos }
    end
  end

  def show
    @transferencia_deposito = TransferenciaDeposito.find(params[:id])

    render layout: 'chart'

  end

  def comprovante
    
    @transferencia_deposito = TransferenciaDeposito.find(params[:id])
 	  @detalhe_produtos = TransferenciaDepositoDetalhe.all(:conditions => ["transferencia_deposito_id = ?", @transferencia_deposito.id])

    render :layout => false
  end

  def new
    @transferencia_deposito = TransferenciaDeposito.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @transferencia_deposito }
    end
  end

  def edit
    @transferencia_deposito = TransferenciaDeposito.find(params[:id])
  end

  def create
    @transferencia_deposito = TransferenciaDeposito.new(params[:transferencia_deposito])
    @transferencia_deposito.usuario_created = current_user.id
    @transferencia_deposito.unidade_created = current_unidade.id

    respond_to do |format|
      if @transferencia_deposito.save
        format.html { redirect_to(@transferencia_deposito, :notice => t('SAVE_SUCESSFUL_MESSAGE')) }
        format.xml  { render :xml => @transferencia_deposito, :status => :created, :location => @transferencia_deposito }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @transferencia_deposito.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @transferencia_deposito = TransferenciaDeposito.find(params[:id])
    @transferencia_deposito.usuario_updated = current_user.id
    @transferencia_deposito.unidade_updated = current_unidade.id

    respond_to do |format|
      if @transferencia_deposito.update_attributes(params[:transferencia_deposito])
        format.html { redirect_to(@transferencia_deposito, :notice => t('SUCESSFUL_EDIT_MESSAGE')) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @transferencia_deposito.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @transferencia_deposito = TransferenciaDeposito.find(params[:id])
    @transferencia_deposito.destroy

    respond_to do |format|
      format.html { redirect_to(transferencia_depositos_url) }
      format.xml  { head :ok }
    end
  end

  def busca
    deposito_origem_id = "AND TD.DEPOSITO_ORIGEM_ID = #{params[:deposito_origem_id]}" unless params[:deposito_origem_id].blank?
    deposito_destino_id = "AND TD.DEPOSITO_DESTINO_ID = '#{params[:deposito_destino_id]}'" unless params[:deposito_destino_id].blank?
    unidade_origem_id = "AND TD.UNIDADE_ORIGEM_ID = #{params[:unidade_origem_id]}" unless params[:unidade_origem_id].blank?
    unidade_destino_id = "AND TD.UNIDADE_DESTINO_ID = #{params[:unidade_destino_id]}" unless params[:unidade_destino_id].blank?

        sql_transf_deposito = "SELECT TD.ID,
          TD.DATA, 
          UO.UNIDADE_NOME AS UNIDADE_ORIGEM,
          DOR.NOME AS DEPOSITO_ORIGEM,
          UD.UNIDADE_NOME AS UNIDADE_DESTINO,
          DD.NOME AS DEPOSITO_DESTINO
    FROM
    TRANSFERENCIA_DEPOSITOS TD
    
    INNER JOIN DEPOSITOS DOR
    ON TD.DEPOSITO_ORIGEM_ID = DOR.ID
    
    INNER JOIN DEPOSITOS DD
    ON TD.DEPOSITO_DESTINO_ID = DD.ID
    
    INNER JOIN UNIDADES UO
    ON TD.UNIDADE_ORIGEM_ID = UO.ID
    
    INNER JOIN UNIDADES UD
    ON TD.UNIDADE_DESTINO_ID = UD.ID
    
    WHERE 
    TD.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'
    #{unidade_origem_id}
    #{unidade_destino_id}
    #{deposito_origem_id}
    #{deposito_destino_id}
    "

    @transf_deposito = Unidade.find_by_sql(sql_transf_deposito)

    
    @transferencia_depositos = TransferenciaDeposito.all
    render :layout => false
end

end
