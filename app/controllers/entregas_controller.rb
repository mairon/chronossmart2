class EntregasController < ApplicationController
  before_filter :authenticate

  def comprovante
    @entrega = Entrega.find(params[:id])
    sqls = "SELECT EV.ID,
                  V.ID AS VENDA_ID,
                  V.PERSONA_NOME,
                  V.DOCUMENTO_NUMERO,
                  V.DIRECAO,
                  (SELECT SUM(VP.QUANTIDADE) FROM VENDAS_PRODUTOS VP WHERE VP.VENDA_ID = V.ID) AS QTD,
                  (SELECT SUM(VP.TOTAL_GUARANI) FROM VENDAS_PRODUTOS VP WHERE VP.VENDA_ID = V.ID) AS TOT_GS,
                  (SELECT SUM(P.PESO) FROM VENDAS_PRODUTOS VP INNER JOIN PRODUTOS P ON P.ID = VP.PRODUTO_ID WHERE VP.VENDA_ID = V.ID) AS TOT_PESO

            FROM ENTREGA_VENDAS EV
            INNER JOIN VENDAS V
            ON V.ID = EV.VENDA_ID
            WHERE ENTREGA_ID = #{@entrega.id}
            ORDER BY ID DESC"
    @entregas_selecionadas = EntregaVenda.find_by_sql(sqls) 
    render layout: false
  end

  def busca
    params[:unidade] = current_unidade.id
    @entregas = Entrega.busca(params)
    render :layout => false
  end

  def add_entregas
    @entrega = Entrega.find(params[:id])

    @insert_lanz = Venda.find(params[:lanz_ids])

    @insert_lanz.each do |il|
      EntregaVenda.create(  :entrega_id  => @entrega.id,
                            :venda_id    => il.id
                          )
    end
    redirect_to(entrega_path(@entrega))
  end

  def index
    @entregas = Entrega.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @entregas }
    end
  end

  def show
    @entrega = Entrega.find(params[:id])
    sqlp = "SELECT V.ID,
                  V.PERSONA_NOME,
                  V.DOCUMENTO_NUMERO,
                  V.DIRECAO,
                  (SELECT SUM(VP.QUANTIDADE) FROM VENDAS_PRODUTOS VP WHERE VP.VENDA_ID = V.ID) AS QTD,
                  (SELECT SUM(P.PESO) FROM VENDAS_PRODUTOS VP INNER JOIN PRODUTOS P ON P.ID = VP.PRODUTO_ID WHERE VP.VENDA_ID = V.ID) AS TOT_PESO

            FROM VENDAS V
            WHERE ENTREGA = 't'
            AND (SELECT COUNT(EV.VENDA_ID) FROM ENTREGA_VENDAS EV WHERE EV.VENDA_ID = V.ID) = 0
            ORDER BY ID DESC"


    sqls = "SELECT EV.ID,
                  V.ID AS VENDA_ID,
                  V.PERSONA_NOME,
                  V.DOCUMENTO_NUMERO,
                  V.DIRECAO,
                  (SELECT SUM(VP.QUANTIDADE) FROM VENDAS_PRODUTOS VP WHERE VP.VENDA_ID = V.ID) AS QTD,
                  (SELECT SUM(P.PESO) FROM VENDAS_PRODUTOS VP INNER JOIN PRODUTOS P ON P.ID = VP.PRODUTO_ID WHERE VP.VENDA_ID = V.ID) AS TOT_PESO

            FROM ENTREGA_VENDAS EV
            INNER JOIN VENDAS V
            ON V.ID = EV.VENDA_ID
            WHERE ENTREGA_ID = #{@entrega.id}
            ORDER BY ID DESC"

    @entregas_pendentes = Venda.find_by_sql(sqlp)
    @entregas_selecionadas = EntregaVenda.find_by_sql(sqls)
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @entrega }
    end
  end

  # GET /entregas/new
  # GET /entregas/new.json
  def new
    @entrega = Entrega.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @entrega }
    end
  end

  # GET /entregas/1/edit
  def edit
    @entrega = Entrega.find(params[:id])
  end

  # POST /entregas
  # POST /entregas.json
  def create
    @entrega = Entrega.new(params[:entrega])
    @entrega.unidade_id = current_unidade.id.to_i

    respond_to do |format|
      if @entrega.save
        format.html { redirect_to @entrega, notice: 'Entrega was successfully created.' }
        format.json { render json: @entrega, status: :created, location: @entrega }
      else
        format.html { render action: "new" }
        format.json { render json: @entrega.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /entregas/1
  # PUT /entregas/1.json
  def update
    @entrega = Entrega.find(params[:id])
    respond_to do |format|
      if @entrega.update_attributes(params[:entrega])
        format.html { redirect_to @entrega, notice: 'Entrega was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @entrega.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /entregas/1
  # DELETE /entregas/1.json
  def destroy
    @entrega = Entrega.find(params[:id])
    @entrega.destroy

    respond_to do |format|
      format.html { redirect_to entregas_url }
      format.json { head :no_content }
    end
  end

  def dynamic_tipo_entrega
    if params[:tipo] == '0'
      @personas = Persona.where(tipo_funcionario: 1)
    else  
      @personas = Persona.where(tipo_transportadora: 1)
    end
    respond_to do |format|
      format.js
    end
  end
end
