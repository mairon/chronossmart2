class PromosController < ApplicationController

  def gera_promo
    @promo = Promo.find(params[:id])

    PromoDt.destroy_all("promo_id = #{@promo.id}" )

    marca     = "and produtos.clase_id = #{@promo.clase_id}" unless @promo.clase.nil?
    colecao   = "and produtos.colecao_id = #{@promo.colecao_id}" unless @promo.colecao.nil?
    grupo     = "and produtos.grupo_id = #{@promo.grupo_id}" unless @promo.grupo.nil?
    sub_grupo = "and produtos.sub_grupo_id = #{@promo.sub_grupo_id}" unless @promo.sub_grupo.nil?

    list_prods = ProdutosTabelaPreco.joins(:produto).where(" produtos_tabela_precos.tabela_preco_id = #{@promo.tabela_preco_id} #{marca} #{colecao} #{grupo} #{sub_grupo}")

    list_prods.each do |l|
      PromoDt.create(
        promo_id: @promo.id,
        produto_id: l.produto_id,
        desc_porce: @promo.percen_desc,
        preco_original_gs: l.preco_1_gs.to_f,
        preco_original_us: l.preco_1_us.to_f,
        preco_venda_gs: (l.preco_1_gs.to_f - (l.preco_1_gs.to_f * (@promo.percen_desc.to_f / 100))),
        preco_venda_us: (l.preco_1_us.to_f - (l.preco_1_us.to_f * (@promo.percen_desc.to_f / 100)))
        )
    end

    redirect_to(promo_path(@promo))
  end

  def index
    @promos = Promo.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @promos }
    end
  end

  # GET /promos/1
  # GET /promos/1.json
  def show
    @promo = Promo.find(params[:id])

    render layout: 'chart'
  end

  # GET /promos/new
  # GET /promos/new.json
  def new
    @promo = Promo.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @promo }
    end
  end

  # GET /promos/1/edit
  def edit
    @promo = Promo.find(params[:id])
  end

  # POST /promos
  # POST /promos.json
  def create
    @promo = Promo.new(params[:promo])

    respond_to do |format|
      if @promo.save
        format.html { redirect_to @promo, notice: 'Promo was successfully created.' }
        format.json { render json: @promo, status: :created, location: @promo }
      else
        format.html { render action: "new" }
        format.json { render json: @promo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /promos/1
  # PUT /promos/1.json
  def update
    @promo = Promo.find(params[:id])

    respond_to do |format|
      if @promo.update_attributes(params[:promo])
        format.html { redirect_to @promo, notice: 'Promo was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @promo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /promos/1
  # DELETE /promos/1.json
  def destroy
    @promo = Promo.find(params[:id])
    @promo.destroy

    respond_to do |format|
      format.html { redirect_to promos_url }
      format.json { head :no_content }
    end
  end
end
