class PedidoComprasPresupuestosController < ApplicationController
  # GET /pedido_compras_presupuestos
  # GET /pedido_compras_presupuestos.json
  def index
    @pedido_compras_presupuestos = PedidoComprasPresupuesto.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @pedido_compras_presupuestos }
    end
  end

  # GET /pedido_compras_presupuestos/1
  # GET /pedido_compras_presupuestos/1.json
  def show
    @pedido_compras_presupuesto = PedidoComprasPresupuesto.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @pedido_compras_presupuesto }
    end
  end

  # GET /pedido_compras_presupuestos/new
  # GET /pedido_compras_presupuestos/new.json
  def new
    @pedido_compras_presupuesto = PedidoComprasPresupuesto.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @pedido_compras_presupuesto }
    end
  end

  # GET /pedido_compras_presupuestos/1/edit
  def edit
    @pedido_compras_presupuesto = PedidoComprasPresupuesto.find(params[:id])
  end

  # POST /pedido_compras_presupuestos
  # POST /pedido_compras_presupuestos.json
  def create
    @pedido_compras_presupuesto = PedidoComprasPresupuesto.new(params[:pedido_compras_presupuesto])

    respond_to do |format|
      if @pedido_compras_presupuesto.save
        format.html { redirect_to @pedido_compras_presupuesto, notice: 'Pedido compras presupuesto was successfully created.' }
        format.json { render json: @pedido_compras_presupuesto, status: :created, location: @pedido_compras_presupuesto }
      else
        format.html { render action: "new" }
        format.json { render json: @pedido_compras_presupuesto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /pedido_compras_presupuestos/1
  # PUT /pedido_compras_presupuestos/1.json
  def update
    @pedido_compras_presupuesto = PedidoComprasPresupuesto.find(params[:id])

    respond_to do |format|
      if @pedido_compras_presupuesto.update_attributes(params[:pedido_compras_presupuesto])
        format.html { redirect_to @pedido_compras_presupuesto, notice: 'Pedido compras presupuesto was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @pedido_compras_presupuesto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pedido_compras_presupuestos/1
  # DELETE /pedido_compras_presupuestos/1.json
  def destroy
    @pedido_compras_presupuesto = PedidoComprasPresupuesto.find(params[:id])
    @pedido_compras_presupuesto.destroy

    respond_to do |format|
      format.html { redirect_to pedido_compras_presupuestos_url }
      format.json { head :no_content }
    end
  end
end
