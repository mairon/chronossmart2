class Tms::PedidoTrasladosController < Tms::TmsController

  def gera_receber
    @pedido_traslado = PedidoTraslado.find(params[:id])
    Cliente.create( persona_id: @pedido_traslado.persona_id,
          persona_nome: @pedido_traslado.persona_nome,
          cota: 1,
          saldo_gs: @pedido_traslado.valor_gs,
          saldo_us: @pedido_traslado.valor_us,
          saldo_rs: @pedido_traslado.valor_rs,
          moeda: @pedido_traslado.moeda,
          liquidacao: 0,
          divida_dolar: @pedido_traslado.valor_us,
          divida_guarani: @pedido_traslado.valor_gs,
          divida_real: @pedido_traslado.valor_rs,
          data: @pedido_traslado.data,
          documento_numero_01: '000',
          documento_numero_02: '000',
          documento_numero: @pedido_traslado.cod_ext.to_s,
          tabela_id: @pedido_traslado.id,
          tabela: 'PEDIDO_TRASLADOS',
          cod_proc: @pedido_traslado.id,
          sigla_proc: 'PT',
          descricao: @pedido_traslado.obs,
          tot_cotas: 1,
          unidade_id: @pedido_traslado.unidade_id,
          vencimento: @pedido_traslado.data)

    redirect_to(:back)
  end

  def busca

    unless params[:inicio].blank?
      data = "AND PT.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' "
    end

    unless params[:busca].blank?
      if params[:tipo] == "CODIGO"
        tipo = "PT.ID"
        cond = "AND #{tipo} = #{params[:busca]} "     
      elsif params[:tipo] == "COD_EXT"
        tipo = "PT.COD_EXT"
        cond =  "AND #{tipo} = #{params[:busca]}"
      else
        tipo = "P.NOME"
        cond =  "AND #{tipo} ILIKE '%#{params[:busca]}%'"
      end
    end

    sql = "SELECT PT.ID,
                  PT.COD_EXT,
                  PT.DATA,
                  PT.TIPO,
                  P.NOME AS PERSONA_NOME,
                  O.NOME AS ORIGEM_NOME,
                  D.NOME AS DESTINO_NOME,
                  PT.MOEDA,
                  PT.VALOR_US,
                  PT.VALOR_GS,
                  PT.VALOR_RS,
                  (SELECT COUNT(OC.ID) FROM ORDEM_CARGAS OC WHERE OC.PEDIDO_TRASLADO_ID = PT.ID) AS CTD_ORDEM_CARGAS
            FROM PEDIDO_TRASLADOS PT
            INNER JOIN PERSONAS P
            ON P.ID = PT.PERSONA_ID

            INNER JOIN CIDADES O
            ON O.ID = PT.ORIGEM_ID

            INNER JOIN CIDADES D
            ON D.ID = PT.DESTINO_ID
            WHERE PT.UNIDADE_ID = #{current_unidade.id} #{data} #{cond}
            "

    @pedido_traslados = PedidoTraslado.paginate_by_sql(sql, page: params[:page], :per_page => 25)
    render :layout => false
  end


  def index
    @pedido_traslados = PedidoTraslado.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @pedido_traslados }
    end
  end

  # GET /pedido_traslados/1
  # GET /pedido_traslados/1.json
  def show
    @pedido_traslado = PedidoTraslado.find(params[:id])

    sql = "SELECT  OS.ID, 
    OS.DATA,
    OS.COD_EXT,
    OS.PEDIDO_TRASLADO_DOC_ID,
    OS.PRODUTO_ID,
    OS.PEDIDO_TRASLADO_ID,
    CV.PLACA AS PLACA_CV,
    CR.PLACA AS PLACA_CR,
      MO.NOME AS MOTORISTA_NOME,
    OS.VALOR_FRETE_GS,
    OS.VALOR_FRETE_US,
    OS.VALOR_FRETE_RS,
    OS.STATUS,
    OS.PESO,
    OS.KM_INICIO,
    OS.KM_FINAL,
    OS.MOEDA,
    ((SELECT PG.DESCRICAO FROM PLANO_DE_CONTAS PG WHERE SUBSTRING(PG.CODIGO, 1, 8) = SUBSTRING(PC.CODIGO, 1, 8) LIMIT 1) || ' > ' || PC.DESCRICAO) AS PLANO_DE_CONTA_NOME
    
FROM ORDEM_CARGAS OS

left JOIN RODADOS CV
ON OS.RODADO_CV_ID = CV.ID

left JOIN RODADOS CR
ON OS.RODADO_CR_ID = CR.ID

left JOIN PERSONAS MO
ON OS.MOTORISTA_ID = MO.ID

left JOIN PLANO_DE_CONTAS PC
ON PC.ID = OS.PLANO_DE_CONTA_ID

WHERE OS.PEDIDO_TRASLADO_ID = #{@pedido_traslado.id}"

@ordem_cargas = OrdemCarga.find_by_sql(sql)

    render layout: 'chart'
  end

  # GET /pedido_traslados/new
  # GET /pedido_traslados/new.json
  def new
    @pedido_traslado = PedidoTraslado.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @pedido_traslado }
    end
  end

  # GET /pedido_traslados/1/edit
  def edit
    @pedido_traslado = PedidoTraslado.find(params[:id])
  end

  # POST /pedido_traslados
  # POST /pedido_traslados.json
  def create

    @pedido_traslado = PedidoTraslado.new(params[:pedido_traslado])

    @pedido_traslado.unidade_id = current_unidade.id
    respond_to do |format|
      if @pedido_traslado.save
        format.html { redirect_to [:tms, @pedido_traslado] }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /pedido_traslados/1
  # PUT /pedido_traslados/1.json
  def update
    @pedido_traslado = PedidoTraslado.find(params[:id])

    respond_to do |format|
      if @pedido_traslado.update_attributes(params[:pedido_traslado])
        format.html { redirect_to [:tms, @pedido_traslado] }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /pedido_traslados/1
  # DELETE /pedido_traslados/1.json
  def destroy
    @pedido_traslado = PedidoTraslado.find(params[:id])
    @pedido_traslado.destroy

    respond_to do |format|
      format.html { redirect_to tms_pedido_traslados_url }
    end
  end
end
