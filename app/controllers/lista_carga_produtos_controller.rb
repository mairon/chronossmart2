class ListaCargaProdutosController < ApplicationController
  # GET /lista_carga_produtos
  # GET /lista_carga_produtos.json
  def index
    @lista_carga_produtos = ListaCargaProduto.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @lista_carga_produtos }
    end
  end

  # GET /lista_carga_produtos/1
  # GET /lista_carga_produtos/1.json
  def show
    @lista_carga_produto = ListaCargaProduto.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @lista_carga_produto }
    end
  end

  # GET /lista_carga_produtos/new
  # GET /lista_carga_produtos/new.json
  def new
    @lista_carga_produto = ListaCargaProduto.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @lista_carga_produto }
    end
  end

  # GET /lista_carga_produtos/1/edit
  def edit
    @lista_carga_produto = ListaCargaProduto.find(params[:id])
  end

  # POST /lista_carga_produtos
  # POST /lista_carga_produtos.json
  def create
    @lista_carga_produto = ListaCargaProduto.new(params[:lista_carga_produto])

    respond_to do |format|
      if @lista_carga_produto.save
        format.html { redirect_to lista_carga_path( @lista_carga_produto.lista_carga_id) }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /lista_carga_produtos/1
  # PUT /lista_carga_produtos/1.json
  def update
    @lista_carga_produto = ListaCargaProduto.find(params[:id])

    respond_to do |format|
      if @lista_carga_produto.update_attributes(params[:lista_carga_produto])
        format.html { redirect_to lista_carga_path( @lista_carga_produto.lista_carga_id) }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /lista_carga_produtos/1
  # DELETE /lista_carga_produtos/1.json
  def destroy
    @lista_carga_produto = ListaCargaProduto.find(params[:id])
    @lista_carga_produto.destroy

    respond_to do |format|
      format.html { redirect_to "/lista_cargas/#{@lista_carga_produto.lista_carga_id}/produtos_adicionados?pedido=#{@lista_carga_produto.presupuesto_id}" }
      format.json { head :no_content }
    end
  end
end
