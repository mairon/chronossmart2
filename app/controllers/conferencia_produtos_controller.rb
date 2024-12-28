class ConferenciaProdutosController < ApplicationController
  # GET /conferencia_produtos
  # GET /conferencia_produtos.json
  def index
    @conferencia_produtos = ConferenciaProduto.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @conferencia_produtos }
    end
  end

  # GET /conferencia_produtos/1
  # GET /conferencia_produtos/1.json
  def show
    @conferencia_produto = ConferenciaProduto.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @conferencia_produto }
    end
  end

  # GET /conferencia_produtos/new
  # GET /conferencia_produtos/new.json
  def new
    @conferencia_produto = ConferenciaProduto.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @conferencia_produto }
    end
  end

  # GET /conferencia_produtos/1/edit
  def edit
    @conferencia_produto = ConferenciaProduto.find(params[:id])
  end

  # POST /conferencia_produtos
  # POST /conferencia_produtos.json
  def create
    @conferencia_produto = ConferenciaProduto.new(params[:conferencia_produto])

    respond_to do |format|
      if @conferencia_produto.save
        format.html { redirect_to "/conferencias/#{@conferencia_produto.conferencia_id}" }
        format.json { render json: @conferencia_produto, status: :created, location: @conferencia_produto }
      else
        format.html { render action: "new" }
        format.json { render json: @conferencia_produto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /conferencia_produtos/1
  # PUT /conferencia_produtos/1.json
  def update
    @conferencia_produto = ConferenciaProduto.find(params[:id])

    respond_to do |format|
      if @conferencia_produto.update_attributes(params[:conferencia_produto])
        format.html { redirect_to "/conferencias/#{@conferencia_produto.conferencia_id}" }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @conferencia_produto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /conferencia_produtos/1
  # DELETE /conferencia_produtos/1.json
  def destroy
    @conferencia_produto = ConferenciaProduto.find(params[:id])
    @conferencia_produto.destroy

    respond_to do |format|
      format.html { redirect_to "/conferencias/#{@conferencia_produto.conferencia_id}" }
      format.json { head :no_content }
    end
  end
end
