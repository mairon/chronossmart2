class ViaticosController < ApplicationController
  def comprovante
    @viatico = Viatico.find(params[:id])

    render :layout => false 
  end

  def index
    @viatico = Viatico.new
    render layout: 'chart'
  end

  def busca_viatico
    params[:unidade] = current_unidade.id
    params[:usuario_id] = current_user.id
    @viaticos = Viatico.filtro_busca_viatico(params)
    render :layout => false
  end

  def show
    @viatico = Viatico.find(params[:id])
    sql = "SELECT C.ID, 
                  C.DATA,
                  C.DOCUMENTO_NUMERO,
                  C.PERSONA_NOME,
                  C.MOEDA,
                  CC.NOME AS CENTRO_CUSTO_NOME,
                  PL.DESCRICAO AS PLANO_DE_CONTA_NOME,
                  CCT.VALOR_US,
                  CCT.VALOR_GS,
                  CCT.VALOR_RS,
                  CF.FACT_AN
              FROM COMPRAS_CUSTOS CCT

              INNER JOIN COMPRAS C
              ON C.ID = CCT.COMPRA_ID

              LEFT JOIN CENTRO_CUSTOS CC
              ON CC.ID = CCT.CENTRO_CUSTO_ID

              LEFT JOIN PLANO_DE_CONTAS PL
              ON PL.ID = CCT.PLANO_DE_CONTA_ID

              INNER JOIN COMPRAS_FINANCAS CF
              ON CF.COMPRA_ID = CCT.COMPRA_ID

              WHERE C.FUNCIONARIO_ID = #{@viatico.persona_id} AND C.FORMA_PAGO_ID = 25 AND CF.FACT_AN = '#{@viatico.id}'
              ORDER BY C.DATA"
    
    @aplicacao_viatico = ComprasCusto.find_by_sql(sql)

    @extrato = Cliente.where(persona_id: @viatico.persona_id, documento_numero_01: 'V00', documento_numero: "#{@viatico.id}" )

    render layout: 'chart'
  end

  # GET /viaticos/new
  # GET /viaticos/new.json
  def new
    @viatico = Viatico.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @viatico }
    end
  end

  # GET /viaticos/1/edit
  def edit
    @viatico = Viatico.find(params[:id])
  end

  # POST /viaticos
  # POST /viaticos.json
  def create
    @viatico = Viatico.new(params[:viatico])
    @viatico.unidade_id = current_unidade.id
    @viatico.usuario_created = current_unidade.usuario_created

    respond_to do |format|
      if @viatico.save
        format.html { redirect_to viaticos_url }
        format.json { render json: @viatico, status: :created, location: @viatico }
      else
        format.html { render action: "new" }
        format.json { render json: @viatico.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /viaticos/1
  # PUT /viaticos/1.json
  def update
    @viatico = Viatico.find(params[:id])

    respond_to do |format|
      if @viatico.update_attributes(params[:viatico])
        format.html { redirect_to viaticos_url }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @viatico.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /viaticos/1
  # DELETE /viaticos/1.json
  def destroy
    @viatico = Viatico.find(params[:id])
    @viatico.destroy

    respond_to do |format|
      format.html { redirect_to viaticos_url }
      format.json { head :no_content }
    end
  end
end
