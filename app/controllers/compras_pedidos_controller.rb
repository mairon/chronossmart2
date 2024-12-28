class ComprasPedidosController < ApplicationController
  # GET /compras_pedidos
  # GET /compras_pedidos.json
  def index
    @compras_pedidos = ComprasPedido.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @compras_pedidos }
    end
  end

  # GET /compras_pedidos/1
  # GET /compras_pedidos/1.json
  def show
    @compras_pedido = ComprasPedido.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @compras_pedido }
    end
  end

  # GET /compras_pedidos/new
  # GET /compras_pedidos/new.json
  def new
    @compras_pedido = ComprasPedido.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @compras_pedido }
    end
  end

  # GET /compras_pedidos/1/edit
  def edit
    @compras_pedido = ComprasPedido.find(params[:id])
  end

  # POST /compras_pedidos
  # POST /compras_pedidos.json
  def create
    @compras_pedido = ComprasPedido.new(params[:compras_pedido])

    respond_to do |format|
      if @compras_pedido.save
        format.html { redirect_to @compras_pedido, notice: 'Compras pedido was successfully created.' }
        format.json { render json: @compras_pedido, status: :created, location: @compras_pedido }
      else
        format.html { render action: "new" }
        format.json { render json: @compras_pedido.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /compras_pedidos/1
  # PUT /compras_pedidos/1.json
  def update
    @compras_pedido = ComprasPedido.find(params[:id])

    respond_to do |format|
      if @compras_pedido.update_attributes(params[:compras_pedido])
        format.html { redirect_to @compras_pedido, notice: 'Compras pedido was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @compras_pedido.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /compras_pedidos/1
  # DELETE /compras_pedidos/1.json
  def destroy
    @compras_pedido = ComprasPedido.find(params[:id])
    @compras_pedido.destroy

    respond_to do |format|
      format.html { redirect_to("/compras/#{@compras_pedido.compra_id}") }
      format.json { head :no_content }
    end
  end
end
