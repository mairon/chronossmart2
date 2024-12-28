class VendaComprasController < ApplicationController

  def baixa_gasto
    @romaneios = Compra.find(params[:compra]["compras_ids"])

    @romaneios.each do |r|
      VendaCompra.create(
        venda_id: params[:venda_id],
        compra_id: r.id
      )
    end   

    redirect_to(financas_venda_path(params[:venda_id]))

  end
  def lista_gastos

    sql = "SELECT C.ID,
                  C.DATA,
                  C.DOCUMENTO_NUMERO,
                  P.NOME AS PERSONA_NOME,
                  PC.DESCRICAO AS PLANO_DE_CONTA_NOME,
                  C.TOTAL_GUARANI AS TOT_GS,
                  C.TOTAL_REAL AS TOT_RS,
                  C.TOTAL_DOLAR AS TOT_US
                  FROM COMPRAS C

                  LEFT JOIN PERSONAS P
                  ON P.ID = C.PERSONA_ID

                  LEFT JOIN PLANO_DE_CONTAS PC
                  ON PC.ID = C.PLANO_DE_CONTA_ID

                  WHERE C.TIPO_COMPRA = 1

                  ORDER BY 1 DESC
    "
    @venda_gastos = Compra.find_by_sql(sql)

    render layout: false
  end

  def index
    @venda_compras = VendaCompra.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @venda_compras }
    end
  end

  # GET /venda_compras/1
  # GET /venda_compras/1.json
  def show
    @venda_compra = VendaCompra.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @venda_compra }
    end
  end

  # GET /venda_compras/new
  # GET /venda_compras/new.json
  def new
    @venda_compra = VendaCompra.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @venda_compra }
    end
  end

  # GET /venda_compras/1/edit
  def edit
    @venda_compra = VendaCompra.find(params[:id])
  end

  # POST /venda_compras
  # POST /venda_compras.json
  def create
    @venda_compra = VendaCompra.new(params[:venda_compra])

    respond_to do |format|
      if @venda_compra.save
        format.html { redirect_to(financas_venda_path(@venda_compra.venda_id)) }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /venda_compras/1
  # PUT /venda_compras/1.json
  def update
    @venda_compra = VendaCompra.find(params[:id])

    respond_to do |format|
      if @venda_compra.update_attributes(params[:venda_compra])
        format.html { redirect_to(financas_venda_path(@venda_compra.venda_id)) }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /venda_compras/1
  # DELETE /venda_compras/1.json
  def destroy
    @venda_compra = VendaCompra.find(params[:id])
    @venda_compra.destroy

    respond_to do |format|
      format.html { redirect_to(financas_venda_path(@venda_compra.venda_id)) }
    end
  end
end
