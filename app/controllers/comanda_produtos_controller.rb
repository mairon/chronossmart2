class ComandaProdutosController < ApplicationController
  # GET /comanda_produtos
  # GET /comanda_produtos.json
  def index
    @comanda_produtos = ComandaProduto.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @comanda_produtos }
    end
  end

  # GET /comanda_produtos/1
  # GET /comanda_produtos/1.json
  def show
    @comanda_produto = ComandaProduto.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @comanda_produto }
    end
  end

  # GET /comanda_produtos/new
  # GET /comanda_produtos/new.json
  def new
    @comanda_produto = ComandaProduto.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @comanda_produto }
    end
  end

  # GET /comanda_produtos/1/edit
  def edit
    @comanda_produto = ComandaProduto.find(params[:id])
  end

  # POST /comanda_produtos
  # POST /comanda_produtos.json
  def create
    @comanda_produto = ComandaProduto.new(params[:comanda_produto])

    respond_to do |format|
      if @comanda_produto.save
        format.html { redirect_to @comanda_produto, notice: 'Comanda produto was successfully created.' }
        format.json { render json: @comanda_produto, status: :created, location: @comanda_produto }
      else
        format.html { render action: "new" }
        format.json { render json: @comanda_produto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /comanda_produtos/1
  # PUT /comanda_produtos/1.json
  def update
    @comanda_produto = ComandaProduto.find(params[:id])

    respond_to do |format|
      if @comanda_produto.update_attributes(params[:comanda_produto])
        format.html { redirect_to @comanda_produto, notice: 'Comanda produto was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @comanda_produto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comanda_produtos/1
  # DELETE /comanda_produtos/1.json
  def destroy
    @comanda_produto = ComandaProduto.find(params[:id])
    @comanda_produto.destroy

    respond_to do |format|
      format.html { redirect_to comanda_produtos_url }
      format.json { head :no_content }
    end
  end
end
