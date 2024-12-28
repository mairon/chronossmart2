class DepositoProdutosController < ApplicationController
  # GET /deposito_produtos
  # GET /deposito_produtos.json
  def index
    @deposito_produtos = DepositoProduto.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @deposito_produtos }
    end
  end

  # GET /deposito_produtos/1
  # GET /deposito_produtos/1.json
  def show
    @deposito_produto = DepositoProduto.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @deposito_produto }
    end
  end

  # GET /deposito_produtos/new
  # GET /deposito_produtos/new.json
  def new
    @deposito_produto = DepositoProduto.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @deposito_produto }
    end
  end

  # GET /deposito_produtos/1/edit
  def edit
    @deposito_produto = DepositoProduto.find(params[:id])
  end

  # POST /deposito_produtos
  # POST /deposito_produtos.json
  def create
    @deposito_produto = DepositoProduto.new(params[:deposito_produto])

    respond_to do |format|
      if @deposito_produto.save  
        format.html { redirect_to "/depositos/#{@deposito_produto.deposito_id}" }
        format.json { render json: @deposito_produto, status: :created, location: @deposito_produto }
      else
        format.html { render action: "new" }
        format.json { render json: @deposito_produto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /deposito_produtos/1
  # PUT /deposito_produtos/1.json
  def update
    @deposito_produto = DepositoProduto.find(params[:id])

    respond_to do |format|
      if @deposito_produto.update_attributes(params[:deposito_produto])
        format.html { redirect_to "/depositos/#{@deposito_produto.deposito_id}" }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @deposito_produto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /deposito_produtos/1
  # DELETE /deposito_produtos/1.json
  def destroy
    @deposito_produto = DepositoProduto.find(params[:id])
    @deposito_produto.destroy

    respond_to do |format|
      format.html { redirect_to "/depositos/#{@deposito_produto.deposito_id}" }
      format.json { head :no_content }
    end
  end
end
