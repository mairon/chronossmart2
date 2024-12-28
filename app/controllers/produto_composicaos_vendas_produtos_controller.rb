class ProdutoComposicaosVendasProdutosController < ApplicationController
  # GET /produto_composicaos_vendas_produtos
  # GET /produto_composicaos_vendas_produtos.json
  def index
    @produto_composicaos_vendas_produtos = ProdutoComposicaosVendasProduto.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @produto_composicaos_vendas_produtos }
    end
  end

  # GET /produto_composicaos_vendas_produtos/1
  # GET /produto_composicaos_vendas_produtos/1.json
  def show
    @produto_composicaos_vendas_produto = ProdutoComposicaosVendasProduto.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @produto_composicaos_vendas_produto }
    end
  end

  # GET /produto_composicaos_vendas_produtos/new
  # GET /produto_composicaos_vendas_produtos/new.json
  def new
    @produto_composicaos_vendas_produto = ProdutoComposicaosVendasProduto.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @produto_composicaos_vendas_produto }
    end
  end

  # GET /produto_composicaos_vendas_produtos/1/edit
  def edit
    @produto_composicaos_vendas_produto = ProdutoComposicaosVendasProduto.find(params[:id])
  end

  # POST /produto_composicaos_vendas_produtos
  # POST /produto_composicaos_vendas_produtos.json
  def create
    @produto_composicaos_vendas_produto = ProdutoComposicaosVendasProduto.new(params[:produto_composicaos_vendas_produto])

    respond_to do |format|
      if @produto_composicaos_vendas_produto.save
        format.html { redirect_to @produto_composicaos_vendas_produto, notice: 'Produto composicaos vendas produto was successfully created.' }
        format.json { render json: @produto_composicaos_vendas_produto, status: :created, location: @produto_composicaos_vendas_produto }
      else
        format.html { render action: "new" }
        format.json { render json: @produto_composicaos_vendas_produto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /produto_composicaos_vendas_produtos/1
  # PUT /produto_composicaos_vendas_produtos/1.json
  def update
    @produto_composicaos_vendas_produto = ProdutoComposicaosVendasProduto.find(params[:id])

    respond_to do |format|
      if @produto_composicaos_vendas_produto.update_attributes(params[:produto_composicaos_vendas_produto])
        format.html { redirect_to @produto_composicaos_vendas_produto, notice: 'Produto composicaos vendas produto was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @produto_composicaos_vendas_produto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /produto_composicaos_vendas_produtos/1
  # DELETE /produto_composicaos_vendas_produtos/1.json
  def destroy
    @produto_composicaos_vendas_produto = ProdutoComposicaosVendasProduto.find(params[:id])
    @produto_composicaos_vendas_produto.destroy

    respond_to do |format|
      format.html { redirect_to produto_composicaos_vendas_produtos_url }
      format.json { head :no_content }
    end
  end
end
