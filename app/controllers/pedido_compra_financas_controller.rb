class PedidoCompraFinancasController < ApplicationController
  # GET /pedido_compra_financas
  # GET /pedido_compra_financas.json
  def index
    @pedido_compra_financas = PedidoCompraFinanca.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @pedido_compra_financas }
    end
  end

  # GET /pedido_compra_financas/1
  # GET /pedido_compra_financas/1.json
  def show
    @pedido_compra_financa = PedidoCompraFinanca.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @pedido_compra_financa }
    end
  end

  # GET /pedido_compra_financas/new
  # GET /pedido_compra_financas/new.json
  def new
    @pedido_compra_financa = PedidoCompraFinanca.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @pedido_compra_financa }
    end
  end

  # GET /pedido_compra_financas/1/edit
  def edit
    @pedido_compra_financa = PedidoCompraFinanca.find(params[:id])
  end

  # POST /pedido_compra_financas
  # POST /pedido_compra_financas.json
  def create
    @pedido_compra_financa = PedidoCompraFinanca.new(params[:pedido_compra_financa])

    respond_to do |format|
      if @pedido_compra_financa.save
        format.html { redirect_to financas_pedido_compra_path(@pedido_compra_financa.pedido_compra_id) }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /pedido_compra_financas/1
  # PUT /pedido_compra_financas/1.json
  def update
    @pedido_compra_financa = PedidoCompraFinanca.find(params[:id])

    respond_to do |format|
      if @pedido_compra_financa.update_attributes(params[:pedido_compra_financa])
        format.html { redirect_to financas_pedido_compra_path(@pedido_compra_financa.pedido_compra_id) }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /pedido_compra_financas/1
  # DELETE /pedido_compra_financas/1.json
  def destroy
    @pedido_compra_financa = PedidoCompraFinanca.find(params[:id])
    @pedido_compra_financa.destroy

    respond_to do |format|
      format.html { redirect_to financas_pedido_compra_path(@pedido_compra_financa.pedido_compra_id) }
    end
  end
end
