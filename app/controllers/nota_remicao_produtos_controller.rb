class NotaRemicaoProdutosController < ApplicationController
  # GET /nota_remicao_produtos
  # GET /nota_remicao_produtos.json
  def index
    @nota_remicao_produtos = NotaRemicaoProduto.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @nota_remicao_produtos }
    end
  end

  # GET /nota_remicao_produtos/1
  # GET /nota_remicao_produtos/1.json
  def show
    @nota_remicao_produto = NotaRemicaoProduto.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @nota_remicao_produto }
    end
  end

  # GET /nota_remicao_produtos/new
  # GET /nota_remicao_produtos/new.json
  def new
    @nota_remicao_produto = NotaRemicaoProduto.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @nota_remicao_produto }
    end
  end

  # GET /nota_remicao_produtos/1/edit
  def edit
    @nota_remicao_produto = NotaRemicaoProduto.find(params[:id])
  end

  # POST /nota_remicao_produtos
  # POST /nota_remicao_produtos.json
  def create
    @nota_remicao_produto = NotaRemicaoProduto.new(params[:nota_remicao_produto])

    respond_to do |format|
      if @nota_remicao_produto.save
        format.html { redirect_to nota_remicao_path(@nota_remicao_produto.nota_remicao_id) }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /nota_remicao_produtos/1
  # PUT /nota_remicao_produtos/1.json
  def update
    @nota_remicao_produto = NotaRemicaoProduto.find(params[:id])

    respond_to do |format|
      if @nota_remicao_produto.update_attributes(params[:nota_remicao_produto])
        format.html { redirect_to nota_remicao_path(@nota_remicao_produto.nota_remicao_id) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /nota_remicao_produtos/1
  # DELETE /nota_remicao_produtos/1.json
  def destroy
    @nota_remicao_produto = NotaRemicaoProduto.find(params[:id])
    @nota_remicao_produto.destroy

    respond_to do |format|
      format.html { redirect_to nota_remicao_path(@nota_remicao_produto.nota_remicao_id) }
    end
  end
end
