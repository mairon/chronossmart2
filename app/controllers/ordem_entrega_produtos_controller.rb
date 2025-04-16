class OrdemEntregaProdutosController < ApplicationController
  # GET /ordem_entrega_produtos
  # GET /ordem_entrega_produtos.json
  def index
    @ordem_entrega_produtos = OrdemEntregaProduto.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @ordem_entrega_produtos }
    end
  end

  # GET /ordem_entrega_produtos/1
  # GET /ordem_entrega_produtos/1.json
  def show
    @ordem_entrega_produto = OrdemEntregaProduto.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @ordem_entrega_produto }
    end
  end

  # GET /ordem_entrega_produtos/new
  # GET /ordem_entrega_produtos/new.json
  def new
    @ordem_entrega_produto = OrdemEntregaProduto.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @ordem_entrega_produto }
    end
  end

  # GET /ordem_entrega_produtos/1/edit
  def edit
    @ordem_entrega_produto = OrdemEntregaProduto.find(params[:id])
  end

  # POST /ordem_entrega_produtos
  # POST /ordem_entrega_produtos.json
  def create
    @ordem_entrega_produto = OrdemEntregaProduto.new(params[:ordem_entrega_produto])

    respond_to do |format|
      if @ordem_entrega_produto.save
        format.html { redirect_to @ordem_entrega_produto }
        format.json { render json: @ordem_entrega_produto, status: :created, location: @ordem_entrega_produto }
        format.js {render text: "$('.modal-body-oe').load('#{modal_add_ordem_entregas_path(venda_id: @ordem_entrega_produto.ordem_entrega.venda_id) }');"}
      else
        format.html { render action: "new" }
        format.json { render json: @ordem_entrega_produto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /ordem_entrega_produtos/1
  # PUT /ordem_entrega_produtos/1.json
  def update
    @ordem_entrega_produto = OrdemEntregaProduto.find(params[:id])

    respond_to do |format|
      if @ordem_entrega_produto.update_attributes(params[:ordem_entrega_produto])
        format.html { redirect_to @ordem_entrega_produto, notice: 'Ordem entrega produto was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @ordem_entrega_produto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ordem_entrega_produtos/1
  # DELETE /ordem_entrega_produtos/1.json
  def destroy
    @ordem_entrega_produto = OrdemEntregaProduto.find(params[:id])
    @ordem_entrega_produto.destroy

    respond_to do |format|
      format.html { redirect_to ordem_entrega_produtos_url }
      format.json { head :no_content }
      format.js {render text: "$('.modal-body-oe').load('#{modal_add_ordem_entregas_path(venda_id: @ordem_entrega_produto.ordem_entrega.venda_id) }');"}
    end
  end
end
