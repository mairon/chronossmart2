class EntregaVendasController < ApplicationController
  # GET /entrega_vendas
  # GET /entrega_vendas.json
  def index
    @entrega_vendas = EntregaVenda.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @entrega_vendas }
    end
  end

  # GET /entrega_vendas/1
  # GET /entrega_vendas/1.json
  def show
    @entrega_venda = EntregaVenda.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @entrega_venda }
    end
  end

  # GET /entrega_vendas/new
  # GET /entrega_vendas/new.json
  def new
    @entrega_venda = EntregaVenda.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @entrega_venda }
    end
  end

  # GET /entrega_vendas/1/edit
  def edit
    @entrega_venda = EntregaVenda.find(params[:id])
  end

  # POST /entrega_vendas
  # POST /entrega_vendas.json
  def create
    @entrega_venda = EntregaVenda.new(params[:entrega_venda])

    respond_to do |format|
      if @entrega_venda.save
        format.html { redirect_to entrega_path(@entrega_venda.entrega_id) }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /entrega_vendas/1
  # PUT /entrega_vendas/1.json
  def update
    @entrega_venda = EntregaVenda.find(params[:id])

    respond_to do |format|
      if @entrega_venda.update_attributes(params[:entrega_venda])
        format.html { redirect_to entrega_path(@entrega_venda.entrega_id) }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /entrega_vendas/1
  # DELETE /entrega_vendas/1.json
  def destroy
    @entrega_venda = EntregaVenda.find(params[:id])
    @entrega_venda.destroy

    respond_to do |format|
      format.html { redirect_to entrega_path(@entrega_venda.entrega_id) }
      format.json { head :no_content }
    end
  end
end
