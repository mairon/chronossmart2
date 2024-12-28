class TransacoesController < ApplicationController
  def index

    sql = "SELECT 
                P.NOME AS PERSONA_NOME,
                SUM(CREDITO_RS - DEBITO_RS) AS SALDO_RS,
                SUM(CREDITO_USDT - DEBITO_USDT) AS SALDO_USDT
            FROM TRANSACOES T
            LEFT JOIN PERSONAS P
            ON P.ID = T.PERSONA_ID
            GROUP BY 1
            ORDER BY 1"

    @saldo_transacoes = Transacao.find_by_sql(sql)

    render layout: 'chart'

  end

  def busca
    persona  = "AND T.PERSONA_ID = #{params[:busca]["persona"]}" unless params[:busca]["persona"].blank?
    operacao = "AND T.OPERACAO = #{params[:operacao]}" unless params[:operacao].blank?

    persona_saldo  = "AND PERSONA_ID = #{params[:busca]["persona"]}" unless params[:busca]["persona"].blank?
    operacao_saldo = "AND OPERACAO = #{params[:operacao]}" unless params[:operacao].blank?

    @saldo_rs = Transacao.where("data < '#{params[:inicio].split("/").reverse.join("-")}' #{persona_saldo} #{operacao_saldo} ").sum("credito_rs - debito_rs")
    @saldo_usdt = Transacao.where("data < '#{params[:inicio].split("/").reverse.join("-")}' #{persona_saldo} #{operacao_saldo} ").sum("credito_usdt - debito_usdt")


    sql = "SELECT T.ID,
                  T.DATA,
                  T.OPERACAO,
                  P.NOME AS PERSONA_NOME,
                  T.OBS,
                  T.QUANTIDADE,
                  T.MOEDA,
                  T.TAXA,
                  T.CREDITO_RS,
                  T.DEBITO_RS,
                  T.CREDITO_USDT,
                  T.DEBITO_USDT,
                  T.TOT_RS
                  FROM TRANSACOES T
                  LEFT JOIN PERSONAS P
                  ON P.ID = T.PERSONA_ID
                  WHERE T.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}'
                  #{persona} #{operacao}
                  
                  ORDER BY 2,1
                  "

    @transacoes = Transacao.find_by_sql(sql)
    render layout: false
  end

  # GET /transacoes/1
  # GET /transacoes/1.json
  def show
    @transacao = Transacao.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @transacao }
    end
  end

  # GET /transacoes/new
  # GET /transacoes/new.json
  def new
    @transacao = Transacao.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @transacao }
    end
  end

  # GET /transacoes/1/edit
  def edit
    @transacao = Transacao.find(params[:id])
  end

  # POST /transacoes
  # POST /transacoes.json
  def create

    @transacao = Transacao.new(params[:transacao])
    @transacao.unidade_id = current_unidade.id

    respond_to do |format|
      if @transacao.save
        format.html { redirect_to transacoes_url }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /transacoes/1
  # PUT /transacoes/1.json
  def update
    @transacao = Transacao.find(params[:id])

    respond_to do |format|
      if @transacao.update_attributes(params[:transacao])
        format.html { redirect_to transacoes_url }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /transacoes/1
  # DELETE /transacoes/1.json
  def destroy
    @transacao = Transacao.find(params[:id])
    @transacao.destroy

    respond_to do |format|
      format.html { redirect_to transacoes_url }
      format.json { head :no_content }
    end
  end
end
