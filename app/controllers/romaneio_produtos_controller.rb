class RomaneioProdutosController < ApplicationController
  # GET /romaneio_produtos
  # GET /romaneio_produtos.json
  def index
    @romaneio_produtos = RomaneioProduto.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @romaneio_produtos }
    end
  end

  # GET /romaneio_produtos/1
  # GET /romaneio_produtos/1.json
  def show
    @romaneio_produto = RomaneioProduto.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @romaneio_produto }
    end
  end

  # GET /romaneio_produtos/new
  # GET /romaneio_produtos/new.json
  def new
    @romaneio_produto = RomaneioProduto.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @romaneio_produto }
    end
  end

  # GET /romaneio_produtos/1/edit
  def edit
    @romaneio_produto = RomaneioProduto.find(params[:id])
  end

  # POST /romaneio_produtos
  # POST /romaneio_produtos.json
  def create
    @romaneio_produto = RomaneioProduto.new(params[:romaneio_produto])

    respond_to do |format|
      if @romaneio_produto.save
        format.html { redirect_to romaneio_path(@romaneio_produto.romaneio_id) }
        
      else
        format.html { render action: "new" }        
      end
    end
  end

  # PUT /romaneio_produtos/1
  # PUT /romaneio_produtos/1.json
  def update
    @romaneio_produto = RomaneioProduto.find(params[:id])

    respond_to do |format|
      if @romaneio_produto.update_attributes(params[:romaneio_produto])
        format.html { redirect_to romaneio_path(@romaneio_produto.romaneio_id) }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /romaneio_produtos/1
  # DELETE /romaneio_produtos/1.json
  def destroy
    @romaneio_produto = RomaneioProduto.find(params[:id])
    @romaneio_produto.destroy

    respond_to do |format|
      format.html { redirect_to romaneio_path(@romaneio_produto.romaneio_id) }
    end
  end
end
