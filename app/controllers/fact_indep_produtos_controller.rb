class FactIndepProdutosController < ApplicationController
  # GET /fact_indep_produtos
  # GET /fact_indep_produtos.json
  def index
    @fact_indep_produtos = FactIndepProduto.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @fact_indep_produtos }
    end
  end

  # GET /fact_indep_produtos/1
  # GET /fact_indep_produtos/1.json
  def show
    @fact_indep_produto = FactIndepProduto.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @fact_indep_produto }
    end
  end

  # GET /fact_indep_produtos/new
  # GET /fact_indep_produtos/new.json
  def new
    @fact_indep_produto = FactIndepProduto.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @fact_indep_produto }
    end
  end

  # GET /fact_indep_produtos/1/edit
  def edit
    @fact_indep_produto = FactIndepProduto.find(params[:id])
  end

  # POST /fact_indep_produtos
  # POST /fact_indep_produtos.json
  def create
    @fact_indep_produto = FactIndepProduto.new(params[:fact_indep_produto])

    respond_to do |format|
      if @fact_indep_produto.save
        format.html { redirect_to fact_indep_path(@fact_indep_produto.fact_indep_id) }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /fact_indep_produtos/1
  # PUT /fact_indep_produtos/1.json
  def update
    @fact_indep_produto = FactIndepProduto.find(params[:id])

    respond_to do |format|
      if @fact_indep_produto.update_attributes(params[:fact_indep_produto])
        format.html { redirect_to fact_indep_path(@fact_indep_produto.fact_indep_id) }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /fact_indep_produtos/1
  # DELETE /fact_indep_produtos/1.json
  def destroy
    @fact_indep_produto = FactIndepProduto.find(params[:id])
    @fact_indep_produto.destroy

    respond_to do |format|
      format.html { redirect_to fact_indep_path(@fact_indep_produto.fact_indep_id) }
    end
  end
end
