class CondicionalProdutosController < ApplicationController
  # GET /condicional_produtos
  # GET /condicional_produtos.json
  def index
    @condicional_produtos = CondicionalProduto.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @condicional_produtos }
    end
  end

  # GET /condicional_produtos/1
  # GET /condicional_produtos/1.json
  def show
    @condicional_produto = CondicionalProduto.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @condicional_produto }
    end
  end

  # GET /condicional_produtos/new
  # GET /condicional_produtos/new.json
  def new
    @condicional_produto = CondicionalProduto.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @condicional_produto }
    end
  end

  # GET /condicional_produtos/1/edit
  def edit
    @condicional_produto = CondicionalProduto.find(params[:id])
  end

  # POST /condicional_produtos
  # POST /condicional_produtos.json
  def create
    @condicional_produto = CondicionalProduto.new(params[:condicional_produto])

    respond_to do |format|
      if @condicional_produto.save

        if @condicional_produto.status == false
          format.html { redirect_to entrada_condicional_path(@condicional_produto.condicional_id) }
        else
          format.html { redirect_to condicional_path(@condicional_produto.condicional_id) }
        end

      else
        format.html { render action: "new" }
        format.json { render json: @condicional_produto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /condicional_produtos/1
  # PUT /condicional_produtos/1.json
  def update
    @condicional_produto = CondicionalProduto.find(params[:id])

    respond_to do |format|
      if @condicional_produto.update_attributes(params[:condicional_produto])

        if @condicional_produto.status == false
          format.html { redirect_to entrada_condicional_path(@condicional_produto.condicional_id) }
        else
          format.html { redirect_to condicional_path(@condicional_produto.condicional_id) }
        end

      else
        format.html { render action: "edit" }
        format.json { render json: @condicional_produto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /condicional_produtos/1
  # DELETE /condicional_produtos/1.json
  def destroy
    @condicional_produto = CondicionalProduto.find(params[:id])
    @condicional_produto.destroy

    respond_to do |format|

        if @condicional_produto.status == false
          format.html { redirect_to entrada_condicional_path(@condicional_produto.condicional_id) }
        else
          format.html { redirect_to condicional_path(@condicional_produto.condicional_id) }
        end

    end
  end
end
