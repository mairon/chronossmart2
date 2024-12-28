class TransfProdutosController < ApplicationController

  def busca
    params[:unidade] = current_unidade.id
    params[:usuario_id] = current_user.id
    @trans_produtos = TransfProduto.filtro_busca(params)
    render :layout => false    
  end

  def index
    @transf_produtos = TransfProduto.all
    @transf_produto = TransfProduto.new

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @transf_produtos }
    end
  end

  # GET /transf_produtos/1
  # GET /transf_produtos/1.json
  def show
    @transf_produto = TransfProduto.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @transf_produto }
    end
  end

  # GET /transf_produtos/new
  # GET /transf_produtos/new.json
  def new
    @transf_produto = TransfProduto.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @transf_produto }
    end
  end

  # GET /transf_produtos/1/edit
  def edit
    @transf_produto = TransfProduto.find(params[:id])
  end

  # POST /transf_produtos
  # POST /transf_produtos.json
  def create
    @transf_produto = TransfProduto.new(params[:transf_produto])
    @transf_produto.unidade_id = current_unidade.id

    respond_to do |format|
      if @transf_produto.save
        format.html { redirect_to transf_produtos_url }
        format.json { render json: @transf_produto, status: :created, location: @transf_produto }
      else
        format.html { render action: "new" }
        format.json { render json: @transf_produto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /transf_produtos/1
  # PUT /transf_produtos/1.json
  def update
    @transf_produto = TransfProduto.find(params[:id])

    respond_to do |format|
      if @transf_produto.update_attributes(params[:transf_produto])
        format.html { redirect_to transf_produtos_url }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @transf_produto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transf_produtos/1
  # DELETE /transf_produtos/1.json
  def destroy
    @transf_produto = TransfProduto.find(params[:id])
    @transf_produto.destroy

    respond_to do |format|
      format.html { redirect_to transf_produtos_url }
      format.json { head :no_content }
    end
  end
end
