class VendasPedidosController < ApplicationController
  # GET /vendas_pedidos
  # GET /vendas_pedidos.json
  def index
    @vendas_pedidos = VendasPedido.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @vendas_pedidos }
    end
  end

  # GET /vendas_pedidos/1
  # GET /vendas_pedidos/1.json
  def show
    @vendas_pedido = VendasPedido.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @vendas_pedido }
    end
  end

  # GET /vendas_pedidos/new
  # GET /vendas_pedidos/new.json
  def new
    @vendas_pedido = VendasPedido.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @vendas_pedido }
    end
  end

  # GET /vendas_pedidos/1/edit
  def edit
    @vendas_pedido = VendasPedido.find(params[:id])
  end

  # POST /vendas_pedidos
  # POST /vendas_pedidos.json
  def create
    @vendas_pedido = VendasPedido.new(params[:vendas_pedido])

    respond_to do |format|
      if @vendas_pedido.save
        format.html { redirect_to "/vendas/#{@vendas_pedido.venda_id}" }
        format.json { render json: @vendas_pedido, status: :created, location: @vendas_pedido }
      else
        format.html { render action: "new" }
        format.json { render json: @vendas_pedido.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /vendas_pedidos/1
  # PUT /vendas_pedidos/1.json
  def update
    @vendas_pedido = VendasPedido.find(params[:id])

    respond_to do |format|
      if @vendas_pedido.update_attributes(params[:vendas_pedido])
        format.html { redirect_to "/vendas/#{@vendas_pedido.venda_id}" }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @vendas_pedido.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vendas_pedidos/1
  # DELETE /vendas_pedidos/1.json
  def destroy
    @vendas_pedido = VendasPedido.find(params[:id])
    @vendas_pedido.destroy

    respond_to do |format|
      format.html { redirect_to "/vendas/#{@vendas_pedido.venda_id}" }
      format.json { head :no_content }
    end
  end
end
