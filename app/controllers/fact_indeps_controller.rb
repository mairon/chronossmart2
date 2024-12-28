class FactIndepsController < ApplicationController

  def baixa_produto
    @fact_indep = FactIndep.find(params[:id])
    @produtos = VendasProduto.find(params[:venda]["produtos_ids"])

    @produtos.each do |d|
      FactIndepProduto.create(  fact_indep_id:    @fact_indep.id,
          produto_id:         d.produto_id,
          quantidade:         d.quantidade,
          unit_gs:            d.unitario_guarani,
          tot_gs:             d.total_guarani,
          produto_nome:       d.produto_nome,
          vendas_produto_id:  d.id
        )
    end

    redirect_to(fact_indep_path(@fact_indep))
  end

  def index
    @fact_indeps = FactIndep.paginate(page: params[:page], :per_page => 25).order('id desc')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @fact_indeps }
    end
  end

  # GET /fact_indeps/1
  # GET /fact_indeps/1.json
  def show
    @fact_indep = FactIndep.find(params[:id])
    sql = "
      SELECT VP.ID,
             VP.PRODUTO_NOME,
             VP.QUANTIDADE,
             VP.UNITARIO_GUARANI,
             VP.TOTAL_GUARANI,
             VP.VENDA_ID,
             VP.DATA
      FROM VENDAS_PRODUTOS VP
      WHERE VP.FATURADO = FALSE 
      AND VP.PERSONA_ID = #{@fact_indep.persona_id}
      AND (SELECT COUNT(FT.ID) FROM FACT_INDEP_PRODUTOS FT WHERE FT.VENDAS_PRODUTO_ID = VP.ID) = 0
      ORDER BY VP.DATA DESC
    "
    @produtos_pendetes = VendasProduto.find_by_sql(sql)
    @produtos_faturados = FactIndepProduto.where(fact_indep_id: @fact_indep.id)
    @fts = FormFiscal.where("sigla_proc = 'FI' AND cod_proc = #{@fact_indep.id} AND STATUS != 0").select("id,impressao, cod_proc, tot_gs, doc_01, doc_02, doc, status").order('id desc ')
    @ft_ativo = FormFiscal.where("sigla_proc = 'FI' AND cod_proc = #{@fact_indep.id} AND STATUS = 1").count(:id)

    render layout: 'chart'
  end

  # GET /fact_indeps/new
  # GET /fact_indeps/new.json
  def new
    @fact_indep = FactIndep.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @fact_indep }
    end
  end

  # GET /fact_indeps/1/edit
  def edit
    @fact_indep = FactIndep.find(params[:id])
  end

  # POST /fact_indeps
  # POST /fact_indeps.json
  def create
    @fact_indep = FactIndep.new(params[:fact_indep])

    respond_to do |format|
      if @fact_indep.save
        format.html { redirect_to @fact_indep }
        format.json { render json: @fact_indep, status: :created, location: @fact_indep }
      else
        format.html { render action: "new" }
        format.json { render json: @fact_indep.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /fact_indeps/1
  # PUT /fact_indeps/1.json
  def update
    @fact_indep = FactIndep.find(params[:id])

    respond_to do |format|
      if @fact_indep.update_attributes(params[:fact_indep])
        format.html { redirect_to @fact_indep }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @fact_indep.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fact_indeps/1
  # DELETE /fact_indeps/1.json
  def destroy
    @fact_indep = FactIndep.find(params[:id])
    @fact_indep.destroy

    respond_to do |format|
      format.html { redirect_to fact_indeps_url }
      format.json { head :no_content }
    end
  end
end
