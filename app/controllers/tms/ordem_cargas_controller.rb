class Tms::OrdemCargasController < Tms::TmsController  

  def index
    render layout: 'chart'
  end

  def busca

    unless params[:inicio].blank?
      data = "AND OS.DATA BETWEEN '#{params[:inicio].split("/").reverse.join("-")}' AND '#{params[:final].split("/").reverse.join("-")}' "
    end

    unless params[:busca].blank?
      if params[:tipo] == "COD_EXT"
        tipo = "OS.COD_EXT"
        cond = "AND #{tipo} = #{params[:busca]} "     
      elsif params[:tipo] == "COD_EXT_PEDIDO"
        tipo = "PT.COD_EXT"
        cond =  "AND #{tipo} = #{params[:busca]}"
      else
        tipo = "MO.NOME"
        cond =  "AND #{tipo} ILIKE '%#{params[:busca]}%'"
      end
    end


      sql = "SELECT  OS.ID, 
      OS.DATA,
      PT.COD_EXT AS PT_COD_EXT,
      PT.TIPO,
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
      PTC.CRT,
      PTC.MIC,
      PTC.CTE,
      PTC.MANIF,
      P.NOME AS PRODUTO_NOME,
      ((SELECT PG.DESCRICAO FROM PLANO_DE_CONTAS PG WHERE SUBSTRING(PG.CODIGO, 1, 8) = SUBSTRING(PC.CODIGO, 1, 8) LIMIT 1) || ' > ' || PC.DESCRICAO) AS PLANO_DE_CONTA_NOME
      
  FROM ORDEM_CARGAS OS

  INNER JOIN PEDIDO_TRASLADOS PT
  ON PT.ID = OS.PEDIDO_TRASLADO_ID

  LEFT JOIN PEDIDO_TRASLADO_DOCS PTC
  ON PTC.ID = OS.PEDIDO_TRASLADO_DOC_ID

  LEFT JOIN PRODUTOS P
  ON P.ID = OS.PRODUTO_ID

  left JOIN RODADOS CV
  ON OS.RODADO_CV_ID = CV.ID

  left JOIN RODADOS CR
  ON OS.RODADO_CR_ID = CR.ID

  left JOIN PERSONAS MO
  ON OS.MOTORISTA_ID = MO.ID

  left JOIN PLANO_DE_CONTAS PC
  ON PC.ID = OS.PLANO_DE_CONTA_ID
  WHERE PT.UNIDADE_ID = #{current_unidade.id} #{data} #{cond} "

  @ordem_cargas = OrdemCarga.find_by_sql(sql)    
  render :layout => false
  end

  def show
    @ordem_carga = OrdemCarga.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @ordem_carga }
    end
  end

  # GET /ordem_cargas/new
  # GET /ordem_cargas/new.json
  def new
    @ordem_carga = OrdemCarga.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @ordem_carga }
    end
  end

  # GET /ordem_cargas/1/edit
  def edit
    @ordem_carga = OrdemCarga.find(params[:id])
  end

  # POST /ordem_cargas
  # POST /ordem_cargas.json
  def create
    @ordem_carga = OrdemCarga.new(params[:ordem_carga])

    respond_to do |format|
      if @ordem_carga.save
        format.html { redirect_to tms_pedido_traslado_path(@ordem_carga.pedido_traslado_id) }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /ordem_cargas/1
  # PUT /ordem_cargas/1.json
  def update
    @ordem_carga = OrdemCarga.find(params[:id])

    respond_to do |format|
      if @ordem_carga.update_attributes(params[:ordem_carga])
        format.html { redirect_to tms_pedido_traslado_path(@ordem_carga.pedido_traslado_id) }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /ordem_cargas/1
  # DELETE /ordem_cargas/1.json
  def destroy
    @ordem_carga = OrdemCarga.find(params[:id])
    @ordem_carga.destroy

    respond_to do |format|
      format.html { redirect_to tms_pedido_traslado_path(@ordem_carga.pedido_traslado_id) }
    end
  end
end
